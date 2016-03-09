import java.io.FilenameFilter;

FilenameFilter fileNameFilter = new FilenameFilter() {   
  @Override
  public boolean accept(File dir, String name) {
    if(!name.startsWith(".")){
      return true;
      }
    else{
      return false;
    }
  }
};


File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles(fileNameFilter);
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(fileNameFilter);
    return names;
  } else {
    return null;
  }
}