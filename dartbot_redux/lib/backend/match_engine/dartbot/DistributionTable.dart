// ignore_for_file: unnecessary_this


class DistributionTable {

  String identifier;
  List<int> table;
  List<int> fields = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20, 1];


  DistributionTable._(this.identifier, this.table);

  factory DistributionTable(String identifier, double rating) {
    List<int> generatedTable;

    switch (identifier) {
      case "Trebles":
        double trebleChange = (rating / 200);
        generatedTable = generateTrebleDT(trebleChange);
        break;
      case "Doubles":
        double doubleChange = ((5.125 * rating + 40) / 1000);
        generatedTable = generateDoubleDT(doubleChange);
        break;
      case "Singles":
        double singleChange = ((-0.06 * (rating * rating) + (12.4 * rating) + 360) / 1000);
        generatedTable = generateSingleDT(singleChange);
        break;
      case "Bullseye":
        double bullChange = ((0.02 * (rating * rating) + 2 * rating + 10) / 1000);
        generatedTable = generateBullDT(bullChange);
        break;
      default:
        throw Exception("Invalid identifier inputted");
    }

    return DistributionTable._(identifier, generatedTable);
  }


    static List<int> generateTrebleDT(double trebleChance) {
        List<int> distroTable = [];
        distroTable.add((trebleChance * 1000).toInt());

        double restChance = 1 - trebleChance;
        // Add chance for single of aimed segment        
        distroTable.add((((0.86 - 0.5 * restChance) * restChance) * 1000).round());

        // Add chances for treble/single of segments left and right of target respectively
        int trebleSideChance = ((0.043 + 0.05 * restChance) * restChance * 1000).round();
        int singleSideChance = ((0.097 + 0.425 * restChance) * restChance * 1000).round();
        distroTable.add((trebleSideChance / 2).round());
        distroTable.add((singleSideChance / 2).round());
        distroTable.add((trebleSideChance / 2).round());
        distroTable.add((singleSideChance / 2).round());

        // Add chances for hitting segments 2 left and 2 right of target
        int farSingleSideChance = (((0.025 * restChance) * restChance) * 1000).round();
        distroTable.add((farSingleSideChance / 2).round());
        distroTable.add((farSingleSideChance / 2).round());

        
        return distroTable;
    }

    static List<int> generateSingleDT(double singleChance) {
        List<int> distroTable = [];
        
        double restChance = 1 - singleChance;

        // Add chance for treble of aimed segment
        distroTable.add((((0.369 - 0.1 * restChance) * restChance) * 1000).round());

        // Add chance for single of aimed segment        
        distroTable.add((singleChance * 1000).round());

        // Add chances for treble/single of segments left and right of target respectively
        int trebleSideChance = ((((0.164 - 0.05 * restChance) * restChance) / 2) * 1000).round();
        int singleSideChance = ((((0.467 + 0.1 * restChance) * restChance) / 2) * 1000).round();
        distroTable.add(trebleSideChance);
        distroTable.add(singleSideChance);
        distroTable.add(trebleSideChance);
        distroTable.add(singleSideChance);

        // Add chances for hitting segments 2 left and 2 right of target
        int farSingleSideChance = ((0.05 * restChance * restChance / 2) * 1000).round();
        distroTable.add(farSingleSideChance);
        distroTable.add(farSingleSideChance);
        
        return distroTable;
    }

    static List<int> generateDoubleDT(double doubleChance) {
        List<int> distroTable = [];
        
        distroTable.add((doubleChance * 1000).round());

        double restChance = 1 - doubleChance;

        // Add chance for hitting outside the board
        distroTable.add((((0.432 + 0.1 * restChance) * restChance) * 1000).round());


        // Add chance for single of aimed segment
        distroTable.add((((0.520 - 0.07 * restChance) * restChance) * 1000).round());

        // Add chances for double/single of segments left and right of target respectively
        int doubleSideChance = ((((0.021 - 0.01 * restChance) * restChance) / 2 * 1000).round());
        int singleSideChance = ((((0.027 - 0.02 * restChance) * restChance) / 2 * 1000).round());
        distroTable.add(doubleSideChance);
        distroTable.add(singleSideChance);
        distroTable.add(doubleSideChance);
        distroTable.add(singleSideChance);
        
        return distroTable;
    }   


    static List<int> generateBullDT(double bullChance) {
        List<int> distroTable = [];
        
        distroTable.add((bullChance * 1000).round());

        double restChance = 1 - bullChance;

        // Add chance for 25
        distroTable.add((((0.849 - 0.3 * restChance) * restChance) * 1000).round());
    
        // Add chance for hitting outside the bull
        distroTable.add((((0.121 + 0.3 * restChance) * restChance) * 1000).round());

        
        return distroTable;
    }

    int getThrowResult(int rngNumber, int aimedNumber) {
        int total = 0;
        int index = 0;
        for (int i in this.table) {
            total += i;
            if (rngNumber <= total) {
                index = this.table.indexOf(i);
                break;
            }
        }

        if (this.identifier == "Bullseye") {
            if (index == 0) {
                return 50;
            } else if (index == 1){
                return 25;
            } else {
                return rngNumber % 20;
                }
            
        }

        return getValueOfIndex(index, aimedNumber);
    }

  

    int getValueOfIndex(int index, int aimedNumber) {
        int leftOfAimed;
        int leftOfLeft;
        int rightOfAimed;
        int rightOfRight;

        try {
            leftOfAimed = this.fields[(fields.indexOf(aimedNumber) - 1)];
            leftOfLeft = fields[(fields.indexOf(aimedNumber) - 2)];
        } on RangeError {
            leftOfAimed = fields[(fields.lastIndexOf(aimedNumber) - 1)];
            leftOfLeft = fields[(fields.lastIndexOf(aimedNumber) - 2)];
        }
        rightOfAimed = fields[(fields.indexOf(aimedNumber) + 1)];
        rightOfRight = fields[(fields.indexOf(aimedNumber) + 2)];
                


        if (this.identifier == ("Trebles") || this.identifier == ("Singles")) {
          List<int> scores = [3 * aimedNumber, aimedNumber,
                              3 * leftOfAimed, leftOfAimed,
                              3 * rightOfAimed, rightOfAimed,
                              leftOfLeft, rightOfRight];
          return scores[index];
        } else {
          List<int> scores = [2 * aimedNumber, 0, aimedNumber,
                              2 * leftOfAimed, leftOfAimed,
                              2 * rightOfAimed, rightOfAimed];
            return scores[index];
            
        }
    }

    @override
    String toString() {
      return "$identifier: $table";
    }

}