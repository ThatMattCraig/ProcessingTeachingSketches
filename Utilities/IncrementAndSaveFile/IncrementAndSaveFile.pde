/*
INCREMENT AND SAVE FILE
 Jeff Thompson | 2013 | www.jeffreythompson.org
 
 Looks at a specified folder and creates an incremental filename to add.
 
 The input pattern assumes the following format:
 file_00005.extension (note: the # of leading 0s can be specified)
 
 The match regex pattern looks for this pattern, but can be modified as needed.
 */

void setup() {
  incrementAndSave(sketchPath(""), 5);    // arguments are location and # of leading zeroes in filename
  
  // alternatively, specify a folder as either a full path or with the sketchPath("") method
  // incrementAndSave(sketchPath("") + "/output", 3);
}


void incrementAndSave(String folder, int leadingZeroes) {
  String name = "file";        // name before number (ex: file_001.png)
  String separator = "_";      // something between name and incremental # (see above example)
  String extension = "png";    // no period!  

  int maxFileNumber = 0;       // used to find the latest file #

  try {
    File dir = new File(folder);        // load directory and get all files
    File[] files = dir.listFiles(); 
    for (File f : files) {   

      // compare to the filename type we're looking for - you may need to change the pattern
      // for your particular files
      String[] findFileNumber = match(f.getName(), ".*?" + separator + "([0-9].*?)\\." + extension);
      if (findFileNumber != null) {                         // if the file matches our pattern
        int number = Integer.parseInt(findFileNumber[1]);   // extract the # from the match
        if (number > maxFileNumber) {                       // if it's larger than our previous record, update
          maxFileNumber = number;
        }
      }
    }
  }
  catch (NullPointerException npe) {      // if folder doesn't exist, make it!
    File newDir = new File(folder);
    newDir.mkdir();
  }

  // create next file number, add leading 0s, and save
  String nextNumber = nf((maxFileNumber+1), leadingZeroes);
  String outputFilename = name + separator + nextNumber + "." + extension;
  save(folder + "/" + outputFilename);
  println(outputFilename);
}

