class ProcessTable{
  int rowCount;
  int columnCount;
  float[][] data;
  String[] rowNames;
  String[] columnNames;
  
  ProcessTable(String fileName){
    String[] rows = loadStrings(fileName);
    String[] pieces;
    String[] columns = split(rows[0], TAB);
    columnNames = subset(columns, 1);
    scrubQuotes(columnNames);
    columnCount = columnNames.length;
    rowNames = new String[rows.length- 1];
    data = new float[rows.length-1][];
    for(int i=1; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue;
      }
      if (rows[i].startsWith("#")) {
        continue;
      }
      
      pieces = split(rows[i], TAB);
      scrubQuotes(pieces);
      rowNames[rowCount] = pieces[0];
      data[rowCount] = parseFloat(subset(pieces, 1));
      rowCount++;
    }
    data = (float[][]) subset(data, 0, rowCount); 
  }
  
  void checkString (String charString) {
    for (int i = 0; i <= columnCount ; i++) {
      if (columnNames[i].startsWith(charString)) {
        println(columnNames[i]);
      }
    }
  }
  
  void convertDataUnit(int row, int var) {
    if (var == 1) {
      for (int i = 0; i < columnCount; i++) {
        data[row][i] = data[row][i] * 1000.00;
        //println(data[row][i]);
      }
    }
    else {
      
      for (int i = 0; i < columnCount; i++) {
        data[row][i] = data[row][i] / 1000;
        println(data[row][i]);
      }
    }
  }
  
  void scrubQuotes(String[] array) {
    for (int i = 0; i < array.length; i++) {
      if (array[i].length() > 2) {
        // remove quotes at start and end, if present
        if (array[i].startsWith("\"") && array[i].endsWith("\"")) {
          array[i] = array[i].substring(1, array[i].length() - 1);
        }
      }
      // make double quotes into single quotes
      array[i] = array[i].replaceAll("\"\"", "\"");
    }
  }
  
   String[] getColumnNames() {
    return columnNames;
  }
  
  String getRowName(int rowIndex) {
    return rowNames[rowIndex];
  }
  
  String getColName(int colIndex) {
    return columnNames[colIndex];
  }
  
  String[] getRowNames() {
    return rowNames;
  }
  
   int getRowCount() {
    return rowCount;
  }
   int getColumnCount() {
    return columnCount;
  }
  
  float getFloat(int rowIndex, int col) {
    return data[rowIndex][col];
  }
  
  String getString(int rowIndex, int col) {
     return Float.toString(data[rowIndex][col]);
  }
  
  boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    //if (col >= columnCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;
    return !Float.isNaN(data[row][col]);
  }
  
  float getTableMin() {
    float m = Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < columnCount; col++) {
        if (isValid(row, col)) {
          if (data[row][col] < m) {
            m = data[row][col];
          }
        }
      }
    }
    return m;
  }


  float getTableMax() {
    float m = -Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < columnCount; col++) {
        if (isValid(row, col)) {
          if (data[row][col] > m) {
            m = data[row][col];
          }
        }
      }
    }
    return m;
  }
  
  float getRowMax(int row) {
    float m = -Float.MAX_VALUE;
    for (int col = 0 ; col < columnCount; col++) {
      if (isValid(row,col)) {
        if (data[row][col] > m) {
          m = data[row][col];
        }
      }
    }
    return m;
  }
  
  float getRowMin(int row) {
    float m = -Float.MAX_VALUE;
    for (int col = 0 ; col < columnCount; col++) {
      if (isValid(row,col)) {
        if (data[row][col] < m) {
          m = data[row][col];
        }
      }
    }
    return m;
  }
  
  int getRowIndex(String regionName) {
    for (int row = 1; row < rowCount; row++ ) {
      if(isValid(row,0)) {
        if (regionName.compareToIgnoreCase(rowNames[row]) == 0) {
          return row;
        }
      }
    }
    return 0;
  }
}
