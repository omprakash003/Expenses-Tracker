      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       PROGRAM-ID. EXPENSE.
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
          05 FS-DATE                  PIC X(10).
          05 FS-AMOUNT                PIC 9(6).
          05 FS-DESCRIPTION           PIC X(30).

       WORKING-STORAGE SECTION.
      *-----------------------
       01 WS-INPUT                     PIC 9(1).
       01 WS-INPUT-RECORD.
          05 WS-DATE                      PIC X(10).
          05 WS-AMOUNT                    PIC 9(6).
          05 WS-DESCRIPTION               PIC X(30).
       01 WS-END-FILE                     PIC X(1) VALUE 'N'.
       01 WS-TOTAL-EXPENSE                PIC 9(10).

       PROCEDURE DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       MAIN-PROCEDURE.
      **
      * The main procedure of the program
      **


           PERFORM  UNTIL WS-INPUT IS EQUAL TO 4
            DISPLAY "EXPENSE TRACKER SYSTEM"
            DISPLAY "1. ADD EXPENSE"
            DISPLAY "2.VIEW TOTAL"
            DISPLAY "3.VIEW RECORDS"
            DISPLAY "4.EXIT"
            ACCEPT WS-INPUT
            EVALUATE WS-INPUT
            WHEN 1

             PERFORM A000-ADD-EXPENSE THRU A000-EXIT
            WHEN 2
            MOVE 'N' TO WS-END-FILE
            INITIALIZE WS-TOTAL-EXPENSE
            PERFORM B000-READ-FILE    THRU B000-EXIT
            WHEN 3
            MOVE 'N' TO WS-END-FILE
            PERFORM C000-DISPLAY-RECORDS THRU C000-EXIT
            WHEN 4
            DISPLAY "Exiting the application"
            WHEN OTHER
            DISPLAY "Wrong Input"
            END-EVALUATE
            END-PERFORM.
            STOP RUN.
       A000-ADD-EXPENSE.
           OPEN EXTEND EXP-FILE.
           DISPLAY "ENTER THE DATE(DD/MM/YYYY)".
           ACCEPT WS-DATE
           DISPLAY "ENTER THE AMOUNT".
           ACCEPT WS-AMOUNT
           DISPLAY "ENTER DESCRIPTION"
           ACCEPT WS-DESCRIPTION
           MOVE WS-DATE        TO FS-DATE
           MOVE WS-AMOUNT      TO FS-AMOUNT
           MOVE WS-DESCRIPTION TO FS-DESCRIPTION
           WRITE FS-RECORD.
           CLOSE EXP-FILE.
           DISPLAY "EXPENSES RECORDED"
           DISPLAY "DATE        : " WS-DATE
           DISPLAY "AMOUNT      : " WS-AMOUNT
           DISPLAY "DESCRIPTION : " WS-DESCRIPTION
           .
       A000-EXIT.
           EXIT.
       B000-READ-FILE.
           OPEN INPUT EXP-FILE.

           PERFORM UNTIL WS-END-FILE = 'Y'
               READ EXP-FILE
               AT END
                  MOVE 'Y' TO WS-END-FILE
               NOT AT END
               ADD FS-AMOUNT TO WS-TOTAL-EXPENSE


           END-PERFORM.
           DISPLAY "YOUR TOTAL EXPENSE  " WS-TOTAL-EXPENSE
           CLOSE EXP-FILE.
       B000-EXIT.
           EXIT.
       C000-DISPLAY-RECORDS.
           OPEN INPUT EXP-FILE
           DISPLAY "DATE           AMOUNT     DESCRIPTION"
           PERFORM UNTIL WS-END-FILE = 'Y'
               READ EXP-FILE
               AT END
                MOVE 'Y' TO WS-END-FILE
                NOT AT END
               DISPLAY FS-DATE "     " FS-AMOUNT "     " FS-DESCRIPTION
           END-PERFORM
           DISPLAY "              END OF RECORDS                       "
           CLOSE EXP-FILE.
       C000-EXIT.
           EXIT.


















       END PROGRAM EXPENSE.
