# Closure!
DQ = (function () {
  
  return (function (df) {
    num.file <- paste(tempdir(), "/dq_num.csv", sep= "");
    cat.file <- paste(tempdir(), '/dq_cat.csv', sep=''); 
    checkDataQuality(data= df, out.file.num= num.file, out.file.cat= cat.file)
    
    if (file.exists(num.file)) {
      DQ.numerical = read.csv(num.file);
      file.remove(num.file);
    } else {
      DQ.numerical = NULL;
    }
    if (file.exists(cat.file)) {
      DQ.categorical = read.csv(cat.file);
      file.remove(cat.file);
    } else {
      DQ.categorical = NULL;
    }
    
    return (list(
      Num = DQ.numerical,
      Cat = DQ.categorical
    ))
  })
  
})() # Run!!