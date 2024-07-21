#CNBGdb数据库内的数据集的下载
#参考教程：
#https://mp.weixin.qq.com/s/cOMMwWQY4hYGCq9FeQzD-A
#https://mp.weixin.qq.com/s/NxF9kJXOSH032Vofzu02oA
library(httr)
library(xml2)
library(rvest)
library(tidyverse)

#首先是主函数
#capture.output(get_cndb_downloadlist('https://ftp.cngb.org/pub/CNSA/data1/CNP0000126'),file = 'cndbg.txt')
#也就是说以后我们想要获得CNBGdb数据库内的数据集的下载链接是需要替换上述数据集链接即可



# 检测路径下是否有fasta文件
detect_fasta <- function(inputpath,file){
  if(str_detect(file,'fasta')){
    return(file.path(inputpath,file))
  }
}

# 提取html元素
sub_text <- function(path){
  dep_path <- content(path) %>% 
    html_elements(xpath = '//tr/td/a') %>% 
    html_text() %>% 
    str_replace('/','')
  return(dep_path)
}

# 提取合并路径信息
get_text <- function(inputpath){
  cndb_path <- GET(inputpath)
  out <- lapply(sub_text(cndb_path),function(x){detect_fasta(inputpath,x)})
  # 解析out
  fa_files <- c()
  for (i in out) {
    if (length(i) != 0) {
      fa_files <- append(fa_files,i)
    }
  }
  # 判断输出项
  if(length(fa_files)==0){
    return(file.path(inputpath,sub_text(cndb_path)))
  } else{
    return(fa_files)
  }
}

# 递归函数，检索任意深度的信息
search_dir <- function(path) {
  out <- get_text(path)
  for(file_path in out) {
    if(str_detect(file_path,'fa')){
      print(file_path)}
    else {
      search_dir(file_path)
    }
  }
}

# 主函数
get_cndb_downloadlist <- function(inputpath) {
  require(httr)
  require(xml2)
  require(rvest)
  # 判断输入路径结尾是否有/
  if(str_detect(inputpath,'/$')){
    # 替换掉
    inputpath <- str_replace(inputpath,'/$','')
  }
  search_dir(inputpath)
}

# 使用时，需修改get_cndb_downloadlist中包裹的路径
capture.output(get_cndb_downloadlist('https://ftp.cngb.org/pub/CNSA/data1/CNP0000126'),file = 'cndbg.txt')

