#在Linux环境中，使用sed和awk管道处理后，使用wget下载。  
# 生成下载脚本
cat cndbg.txt | sed 's/\[1\] //' | sed 's/"//g'| while read id;do (echo wget -c $id);done> download_cngbdb.sh
# 运行脚本
#sh download_cngbdb.sh

# 从原始文件中提取包含 .fasta 的行，下载处理好的数据
grep '\.fasta' download_cngbdb.sh > fasta_download_cngbdb.sh

# 从原始文件中提取包含 .fastq 的行,下载原始数据
grep '\.fastq' download_cngbdb.sh > fastq_download_cngbdb.sh

# 运行脚本
nohup sh  fasta_download_cngbdb.sh &
