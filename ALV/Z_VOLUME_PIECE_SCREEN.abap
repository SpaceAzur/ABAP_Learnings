*&---------------------------------------------------------------------*
*&  Include           ZREPORT_FI_SCREEN
*&---------------------------------------------------------------------*


*& Ecran de sélection
SELECTION-SCREEN BEGIN OF BLOCK b1
                WITH FRAME TITLE text-t01.

SELECT-OPTIONS :    so_bukrs  FOR   bkpf-bukrs,
                    so_gjahr  FOR   bkpf-gjahr,
                    so_monat  FOR   bkpf-monat,
                    so_bldat  FOR   bkpf-bldat,
                    so_budat  FOR   bkpf-budat.

SELECTION-SCREEN SKIP 1.

PARAMETERS :        bypiece   RADIOBUTTON GROUP choi.

SELECT-OPTIONS :    so_blart   FOR  bkpf-blart.

SELECTION-SCREEN SKIP 1.

PARAMETERS :        byusers   RADIOBUTTON GROUP choi.

SELECT-OPTIONS :    so_usnam   FOR  usr02-bname.

SELECTION-SCREEN END OF BLOCK b1.