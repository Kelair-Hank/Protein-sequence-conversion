# Protein-sequence-conversion
Introduction:
2 script programs used to convert a protein sequence from 3 letters represent each amino acid to 1 letter represent each amino acid.

Features:
"Protein sequence conversion.jl" read original protein sequence with 3 letters represent each amino acid from a txt file, correct the wrong amino acid sequences due to copy and paste from a PDF file. The correction will be done via both 
regular expression substitution and machine learning (stemming). Then, convert the protein sequence to 1 letter represent each amino acid. Output the new sequence in an EXCEL file named "final.xlsx".
Since the wrong amino acid sequences can't be 100% corrected by the 1st script program, there could be a few wrong amino acid sequences in "final.xlsx" need to be corrected manually and manually find their corresponding 1 letter 
amino acid sequences.
"Create protein fasta file.jl" read EXCEL file "final.xlsx", extract its 1 letter amino acid sequences and output it into a fasta file.

Implementation:
1. Create a unique directory for your protein sequence conversion. Copy and paste the protein sequence from the original PDF file into a txt file named "Raw protein sequence.txt". 
2. Copy and paste the 2 script programs "Protein sequence conversion.jl" and "Create protein fasta file.jl" into the directory storing the txt file.
3. Open julia language on your computer.

4. Change working directory to the directory storing the txt file and script programs with the following julia language code:

    cd("C:\\directory layer 1\\directory layer 2")

    Notice: each layer of directory need to be separated by a "\\".

5. Install the following julia packages if you haven't installed them yet. Enter code:

    using Pkg;Pkg.add("DataFrames")
    Pkg.add("XLSX")
    Pkg.add("Pipe")
    Pkg.add("TextAnalysis")

6. Run 1st script program. Enter code:

    include("Protein sequence conversion.jl")

7. Correct wrong amino acid sequences in EXCEL file "final.xlsx" manually and manually find their corresponding 1 letter amino acid sequences.

8. Run 2nd script program. Enter code:

    include("Create protein fasta file.jl")

