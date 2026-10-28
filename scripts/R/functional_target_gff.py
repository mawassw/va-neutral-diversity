"""functional_target_gff.py -- per-sequence annotated target lengths from one NCBI GFF3/GTF.

Helper for scripts/R/functional_target.R, which calls it once per assembly:

    python -I scripts/R/functional_target_gff.py <annotation> <out.csv> [zip-entry-regex]

<annotation> is a GFF3 (NCBI RefSeq/GenBank style), an NCBI GTF (*.gtf), or an NCBI
Datasets zip, in which case the single entry matching the regex (default
'genomic\\.gff$') is streamed without unpacking. The file is streamed once.

Feature classes (strand ignored; every length is a collapsed union, so no base is
counted twice):
  CDS       every CDS row (as fetch_extract_assemblies.R / data_gen_2.R)
  coding    exons of mRNA and immunoglobulin/TCR gene-segment transcripts
  nc        exons of every other transcript (lnc_RNA/lncRNA, snoRNA, snRNA, tRNA,
            rRNA, misc_RNA, ncRNA, primary_transcript, scaRNA, SRP_RNA, RNase_*,
            Y_RNA, guide_RNA, antisense_RNA, and 'transcript' = non-coding variants)
  excluded  exons of pseudogenes: gene_biotype containing 'pseudogene', type
            starting 'pseudogen', or pseudo=true on the gene or transcript
Output, one row per sequence id carrying any CDS or exon:
  seqid, L_cds (|CDS|), L_cds_stranded (CDS collapsed per strand and summed, the
  GenomicRanges::reduce() default used by data_gen_2.R), L_cds_mrna (|CDS u coding|),
  L_annot (|CDS u coding u nc|), L_nc_exon (|nc|, overlap with coding not removed),
  max_end (largest feature end, incl. 'region' rows).
So L_utr = L_cds_mrna - L_cds and the ncRNA increment = L_annot - L_cds_mrna.
"""
import csv
import re
import sys
import zipfile
from array import array

import numpy as np

CODING_TYPES = {"mRNA", "C_gene_segment", "V_gene_segment", "D_gene_segment",
                "J_gene_segment"}
SKIP_TYPES = {"region", "cDNA_match", "match", "match_part", "CDS", "exon",
              "start_codon", "stop_codon", "five_prime_UTR", "three_prime_UTR",
              "sequence_feature", "enhancer", "silencer", "repeat_region"}


def union_len(starts, ends):
    """Length of the union of closed integer intervals [s, e]."""
    if len(starts) == 0:
        return 0
    s = np.frombuffer(starts, dtype=np.int64)
    e = np.frombuffer(ends, dtype=np.int64)
    o = np.argsort(s, kind="stable")
    s = s[o]; e = e[o]
    cm = np.maximum.accumulate(e)
    new = np.empty(len(s), dtype=bool)
    new[0] = True
    new[1:] = s[1:] > cm[:-1]
    first = np.flatnonzero(new)
    last = np.append(first[1:] - 1, len(s) - 1)
    return int(np.sum(cm[last] - s[first] + 1))


class Store:
    def __init__(self):
        self.d = {}
        self.max_end = {}

    def add(self, seqid, key, start, end):
        k = (seqid, key)
        if k not in self.d:
            self.d[k] = (array("q"), array("q"))
        a, b = self.d[k]
        a.append(start); b.append(end)

    def note_end(self, seqid, end):
        if end > self.max_end.get(seqid, 0):
            self.max_end[seqid] = end

    def get(self, seqid, *keys):
        a, b = array("q"), array("q")
        for key in keys:
            if (seqid, key) in self.d:
                x, y = self.d[(seqid, key)]
                a.extend(x); b.extend(y)
        return a, b


def is_pseudo_biotype(bt):
    return bt is not None and "pseudogene" in bt


def gff_attrs(col9):
    out = {}
    for kv in col9.rstrip("\n;").split(";"):
        if "=" in kv:
            k, v = kv.split("=", 1)
            out[k] = v
    return out


def parse_gff(lines, st):
    cls = {}          # feature ID -> 'gene' | 'pseudo' | 'coding' | 'nc'
    orphan = 0
    for line in lines:
        if line.startswith("#"):
            continue
        f = line.split("\t")
        if len(f) < 9:
            continue
        seqid, ftype = f[0], f[2]
        start, end = int(f[3]), int(f[4])
        st.note_end(seqid, end)
        if ftype == "CDS":
            st.add(seqid, "cds+" if f[6] != "-" else "cds-", start, end)
            continue
        if ftype == "exon":
            a = gff_attrs(f[8])
            par = a.get("Parent", "").split(",")[0]
            c = cls.get(par)
            if c is None:
                orphan += 1
                c = "nc"
            if c == "gene":
                c = "nc"
            if a.get("pseudo") == "true":
                c = "pseudo"
            if c in ("coding", "nc"):
                st.add(seqid, c, start, end)
            continue
        if ftype in SKIP_TYPES:
            continue
        a = gff_attrs(f[8])
        fid = a.get("ID")
        if fid is None:
            continue
        par = a.get("Parent")
        pseudo = (a.get("pseudo") == "true" or ftype.startswith("pseudogen")
                  or is_pseudo_biotype(a.get("gene_biotype")))
        if par is None:                                   # gene-level feature
            cls[fid] = "pseudo" if pseudo else "gene"
        else:                                             # transcript-level feature
            pc = cls.get(par.split(",")[0], "gene")
            if pseudo or pc == "pseudo":
                cls[fid] = "pseudo"
            elif ftype in CODING_TYPES:
                cls[fid] = "coding"
            else:
                cls[fid] = "nc"
    return orphan


GTF_KV = re.compile(r'(\S+) "([^"]*)"')


def parse_gtf(lines, st):
    gene_pseudo = set()
    for line in lines:
        if line.startswith("#"):
            continue
        f = line.split("\t")
        if len(f) < 9:
            continue
        seqid, ftype = f[0], f[2]
        start, end = int(f[3]), int(f[4])
        st.note_end(seqid, end)
        if ftype == "CDS":
            st.add(seqid, "cds+" if f[6] != "-" else "cds-", start, end)
            continue
        if ftype not in ("gene", "exon"):
            continue
        a = dict(GTF_KV.findall(f[8]))
        if ftype == "gene":
            if is_pseudo_biotype(a.get("gene_biotype")) or a.get("pseudo") == "true":
                gene_pseudo.add(a.get("gene_id"))
            continue
        tb = a.get("transcript_biotype", "")
        if (a.get("gene_id") in gene_pseudo or a.get("pseudo") == "true"
                or "pseudo" in tb):
            continue
        st.add(seqid, "coding" if tb in CODING_TYPES else "nc", start, end)
    return 0


def open_lines(path, entry_regex):
    if path.lower().endswith(".zip"):
        zf = zipfile.ZipFile(path)
        hits = [n for n in zf.namelist() if re.search(entry_regex, n)]
        if len(hits) != 1:
            sys.exit(f"{path}: expected one entry matching {entry_regex}, got {hits}")
        fh = zf.open(hits[0])
        name = hits[0]
    else:
        fh = open(path, "rb")
        name = path
    return name, (ln.decode("utf-8", "replace") for ln in fh)


def main():
    path, out = sys.argv[1], sys.argv[2]
    entry = sys.argv[3] if len(sys.argv) > 3 else r"genomic\.gff$"
    name, lines = open_lines(path, entry)
    st = Store()
    orphan = parse_gtf(lines, st) if name.lower().endswith(".gtf") else parse_gff(lines, st)
    seqids = sorted({k[0] for k in st.d})
    with open(out, "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["seqid", "L_cds", "L_cds_stranded", "L_cds_mrna", "L_annot",
                    "L_nc_exon", "max_end"])
        for s in seqids:
            cp, cm_ = st.get(s, "cds+"), st.get(s, "cds-")
            w.writerow([s,
                        union_len(*st.get(s, "cds+", "cds-")),
                        union_len(*cp) + union_len(*cm_),
                        union_len(*st.get(s, "cds+", "cds-", "coding")),
                        union_len(*st.get(s, "cds+", "cds-", "coding", "nc")),
                        union_len(*st.get(s, "nc")),
                        st.max_end.get(s, 0)])
    print(f"{name}: {len(seqids)} sequences; exons with unresolved parent: {orphan}")


if __name__ == "__main__":
    main()
