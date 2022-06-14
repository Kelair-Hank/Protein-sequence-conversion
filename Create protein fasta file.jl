using DataFrames, XLSX, Pipe, TextAnalysis
final=@pipe XLSX.readtable("final.xlsx","Sheet1") |> DataFrames.DataFrame(_...)
fasta=string(final.x3...)

# The following output file name may need to be changed each time.
write("Sequence.fasta",fasta)
