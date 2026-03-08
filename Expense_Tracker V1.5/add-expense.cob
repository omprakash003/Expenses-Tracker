      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       PROGRAM-ID. ADD-EXPENSE.
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
       01 WS-REC.
           05 WS-DATE         PIC X(10).
           05 WS-AMOUNT       PIC 9(6).
           05 WS-DESCRIPTION  PIC X(30).
       PROCEDURE DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       MAIN-PROCEDURE.
      **
      * The main procedure of the program
      **
           OPEN EXTEND EXP-FILE.

           ACCEPT WS-DATE

           ACCEPT WS-AMOUNT

           ACCEPT WS-DESCRIPTION
           MOVE WS-REC TO FS-RECORD
           WRITE FS-RECORD.
           CLOSE EXP-FILE.
            DISPLAY "EXPENSES RECORDED".

            STOP RUN.

      ** add other procedures here
       END PROGRAM ADD-EXPENSE.
