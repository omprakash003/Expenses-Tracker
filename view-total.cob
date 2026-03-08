      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       PROGRAM-ID. VIEW-TOTAL.
       ENVIRONMENT DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       CONFIGURATION SECTION.
      *-----------------------
       INPUT-OUTPUT SECTION.
      *-----------------------
       FILE-CONTROL.
           SELECT EXP-FILE  ASSIGN TO "expenses.dat"
            ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       FILE SECTION.
      *-----------------------
       FD EXP-FILE.
       01 FS-RECORD.
        COPY expense_record.
       WORKING-STORAGE SECTION.
      *-----------------------
       01 WS-TOTAL-EXPENSE                    PIC 9(11) VALUE 0.
       01 WS-END-FILE                     PIC X(1) VALUE 'N'.
       PROCEDURE DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       MAIN-PROCEDURE.
      **
      * The main procedure of the program
      **
            OPEN INPUT EXP-FILE.

           PERFORM UNTIL WS-END-FILE = 'Y'
               READ EXP-FILE
               AT END
                  MOVE 'Y' TO WS-END-FILE
               NOT AT END
               ADD EXP-AMOUNT TO WS-TOTAL-EXPENSE


           END-PERFORM.
           DISPLAY "YOUR TOTAL EXPENSE  " WS-TOTAL-EXPENSE
           CLOSE EXP-FILE.
            STOP RUN.
      ** add other procedures here
       END PROGRAM VIEW-TOTAL.
