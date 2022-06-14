seq1=read("Raw protein sequence.txt",String)

using DataFrames, XLSX, Pipe, TextAnalysis
seq1=replace(seq1,r"\n|\.|\r|\d"=>"")
seq1=replace(seq1,r"Llys"=>"Lys")
seq1=replace(seq1,r"Lieu"=>"Leu")
seq1=replace(seq1,r"Glin"=>"Gln")
v1=split(seq1,r"\s+")

# Correct invalid amino acids.
DataFrames.filter!(ele->(ele != "OO")&&(ele != "O"),v1)
DataFrames.filter!(ele->(ele != "s")&&(ele != "st")&&(ele != "OS")&&(ele != "Os"),v1)

function prefix_suffix(v0::Vector{SubString{String}})
    for i=1:length(v0)
        if occursin(r"^OO",v0[i])||occursin(r"^O",v0[i])||occursin(r"SOO$",v0[i])||occursin(r"SO$",v0[i])||occursin(r"OO$",v0[i])||occursin(r"O$",v0[i])
            println("TRUE")
        end
    end
end

prefix_suffix(v1)

function correct_amino(v0::Vector{SubString{String}})
    for i=1:length(v0)
        if occursin(r"^OO",v0[i])
            v0[i]=replace(v0[i],r"(^OO)(?<amino>.+)"=>s"\g<amino>")
        end
        if occursin(r"^O",v0[i])
            v0[i]=replace(v0[i],r"(^O)(?<amino2>.+)"=>s"\g<amino2>")
        end
        if occursin(r"SOO$",v0[i])
            v0[i]=replace(v0[i],r"(?<amino3>.+)(SOO$)"=>s"\g<amino3>")
        end
        if occursin(r"SO$",v0[i])
            v0[i]=replace(v0[i],r"(?<amino4>.+)(SO$)"=>s"\g<amino4>")
        end
        if occursin(r"OO$",v0[i])
            v0[i]=replace(v0[i],r"(?<amino5>.+)(OO$)"=>s"\g<amino5>")
        end
        if occursin(r"O$",v0[i])
            v0[i]=replace(v0[i],r"(?<amino6>.+)(O$)"=>s"\g<amino6>")
        end
    end
    return v0
end

v1=correct_amino(v1)
trans1=@pipe XLSX.readtable("trans_amino_acid.xlsx","Sheet1") |> DataFrames.DataFrame(_...)
trans1=DataFrames.unique(trans1,Symbol("3letter"))
letter3=trans1[:,Symbol("3letter")]

for i=1:length(v1), j=letter3
    if length(v1[i])>3
        amino=TextAnalysis.StringDocument.(String[v1[i],j])
        cp1=TextAnalysis.Corpus(amino)
        TextAnalysis.stem!(cp1)
        if TextAnalysis.text(cp1[1])==TextAnalysis.text(cp1[2])
            v1[i]=TextAnalysis.text(cp1[2])
        end
    end
end

# Show all invalid amino acids.
v2=collect(1:length(v1))
m1=[v2 v1]
df1=DataFrames.DataFrame(m1)
df1.x2=string.(df1.x2)
df2=DataFrames.filter(row->(length(row.x2)<3)||(length(row.x2)>3),df1)
df_uniq=DataFrames.unique(df2,:x2)
df1[!,:x3] = repeat(["",],nrow(df1))

# Convert amino acids to one letter:
for i=1:nrow(df1), j=1:nrow(trans1)
    if df1.x2[i]==trans1[j,Symbol("3letter")]
        df1.x3[i]=trans1.single_letter[j]
    end
end

XLSX.writetable("final.xlsx",df1,overwrite=true)


