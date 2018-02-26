
# Closure!
DQ = (function (Setup) {
  
  return (function (df) {
    num.file <- paste(tempdir(), "/dq_num.csv", sep= "")
    cat.file <- paste(tempdir(), "/dq_cat.csv", sep= "")
    checkDataQuality(data= df, out.file.num= num.file, out.file.cat= cat.file)
    
    DQ.numerical = read.csv(paste(tempdir(), '/dq_num.csv', sep= ''))
    DQ.categorical = read.csv(paste(tempdir(), '/dq_cat.csv', sep= ''))
    
    # Don't pollute the local system
    #file.remove(paste(tempdir(), '/dq_num.csv', sep= ''));
    #file.remove(paste(tempdir(), '/dq_cat.csv', sep= ''));
    
    return (list(
      Num = DQ.numerical,
      Cat = DQ.categorical
    ))
  })
  
})(Setup) # Run!!