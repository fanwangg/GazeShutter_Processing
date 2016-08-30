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

void outputTable( ArrayList<Trail> trails){
  if(trails == null)
    return;

  Table table = new Table();

  table.addColumn("UserId");
  table.addColumn("TrailId");
  table.addColumn("Direction");
  table.addColumn("Target");
  table.addColumn("Distance");
  table.addColumn("Mode");
  table.addColumn("T_2");
  table.addColumn("T_4");
  table.addColumn("T_Shutter");

  
  for(Trail t:trails){
    TableRow newRow = table.addRow();
    newRow.setInt("UserId", t.userID);
    newRow.setInt("TrailId", t.trailID);
    newRow.setString("Direction", t.design.name());
    newRow.setInt("Target", t.target);
    newRow.setString("Distance", t.calcDistance().name());
    newRow.setString("Mode",t.mode.name());
    newRow.setInt("T_2", t.calcStage2Time());
    newRow.setInt("T_4", t.calcStage4Time());
    newRow.setInt("T_Shutter", t.calcShutterTime());

  }
  int UserId = trails.get(0).userID;
  saveTable(table, "data/"+UserId+'/'+UserId+".csv");
}
