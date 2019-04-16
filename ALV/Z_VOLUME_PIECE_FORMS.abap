*&---------------------------------------------------------------------*
*&  Include           ZREPORT_FI_SELECT
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       Extraction des pièces comptables
*----------------------------------------------------------------------*
FORM get_data.

*----Récupèration des données comptables dans la table bkpf
  SELECT bukrs belnr blart tcode bktxt gjahr monat bldat usnam budat
         INTO TABLE gt_compta
         FROM bkpf WHERE bukrs IN so_bukrs AND gjahr IN so_gjahr
                                           AND monat IN so_monat
                                           AND bldat IN so_bldat
                                           AND budat IN so_budat
                                           AND blart IN so_blart
                                           AND usnam IN so_usnam.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE text-001 TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.
    SORT gt_compta BY bukrs gjahr.
  ENDIF.

ENDFORM. "get_data

*&---------------------------------------------------------------------*
*&      Form  manage_data
*&---------------------------------------------------------------------*
*       Synthèse - Cumul des lignes par type de pièce comptable
*----------------------------------------------------------------------*

FORM manage_data_by_piece.

*----Je récupère la description des types de pièces comptable en t003t

  SELECT blart ltext  INTO TABLE gt_dpiece
                      FROM t003t
                      WHERE spras = sy-langu AND blart IN so_blart.
  SORT gt_dpiece BY blart.
  DELETE ADJACENT DUPLICATES FROM gt_dpiece COMPARING blart.

*----Sélection pour le type de pièce demandé

  CLEAR gs_compta.
  SORT gt_compta BY blart gjahr monat.
  LOOP AT gt_compta INTO gs_compta.
    gs_bypiece-gjahr = gs_compta-gjahr.
    gs_bypiece-monat = gs_compta-monat.
    gs_bypiece-blart = gs_compta-blart.
    gs_bypiece-count = 1.

*----J'ajoute la description du type de pièce comptable

    READ TABLE gt_dpiece INTO gs_dpiece WITH KEY blart = gs_bypiece-blart BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      gs_bypiece-ltext = gs_dpiece-ltext.
    ENDIF.
    COLLECT gs_bypiece INTO gt_bypiece.
    CLEAR gs_bypiece.
  ENDLOOP.

ENDFORM. "manage_data_by_piece

*&---------------------------------------------------------------------*
*&      Form  manage_date_by_user
*&---------------------------------------------------------------------*
*       Synthèse - Cumul des lignes par utilisateur
*----------------------------------------------------------------------*
FORM manage_data_by_user.

  CLEAR gs_compta.
  SORT gt_compta BY usnam gjahr monat.
  LOOP AT gt_compta INTO gs_compta.
    gs_byuser-usnam = gs_compta-usnam.
    gs_byuser-gjahr = gs_compta-gjahr.
    gs_byuser-monat = gs_compta-monat.
    gs_byuser-count = 1.
    COLLECT gs_byuser INTO gt_byuser.
    CLEAR gs_byuser.
  ENDLOOP.

  IF sy-subrc NE 0.
    MESSAGE text-005 TYPE 'E'.
  ENDIF.

ENDFORM.                    "manage_data_by_user


*&---------------------------------------------------------------------*
*&      Form  display_data_by_piece
*&---------------------------------------------------------------------*
*       Affichage par type de pièce comptable
*----------------------------------------------------------------------*
FORM display_alv_by_piece.

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'BLART'.
  gs_fieldcat-ref_tabname = 'BKPF'.
  gs_fieldcat-col_pos = 1.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'LTEXT'.
  gs_fieldcat-ref_tabname = 'T003T'.
  gs_fieldcat-col_pos = 2.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'GJAHR'.
  gs_fieldcat-ref_tabname = 'BKPF'.
  gs_fieldcat-col_pos = 3.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'MONAT'.
  gs_fieldcat-ref_tabname = 'BKPF'.
  gs_fieldcat-col_pos = 4.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'COUNT'.
  gs_fieldcat-seltext_l = text-t02.
  gs_fieldcat-seltext_m = text-t06.
  gs_fieldcat-seltext_s = text-t07.
  gs_fieldcat-col_pos = 5.
  APPEND gs_fieldcat  TO gt_fieldcat .

  ls_layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = l_repid
      is_layout          = ls_layout
      it_fieldcat        = gt_fieldcat
      is_print           = gs_print
    TABLES
      t_outtab           = gt_bypiece
    EXCEPTIONS
      program_error      = 1.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM. "display_alv_by_piece


*&---------------------------------------------------------------------*
*&      Form  display_data_by_user
*&---------------------------------------------------------------------*
*       Affichage par utilisateur
*----------------------------------------------------------------------*
FORM display_alv_by_user.

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'USNAM'.
  gs_fieldcat-ref_tabname = 'BKPF'.
  gs_fieldcat-col_pos = 1.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'GJAHR'.
  gs_fieldcat-ref_tabname = 'BKPF'.
  gs_fieldcat-col_pos = 2.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'MONAT'.
  gs_fieldcat-ref_tabname = 'BKPF'.
  gs_fieldcat-col_pos = 3.
  APPEND gs_fieldcat  TO gt_fieldcat .

  CLEAR gs_fieldcat .
  gs_fieldcat-fieldname = 'COUNT'.
  gs_fieldcat-seltext_l = text-t02.
  gs_fieldcat-seltext_m = text-t03.
  gs_fieldcat-seltext_s = text-t04.
  gs_fieldcat-col_pos = 4.
  APPEND gs_fieldcat  TO gt_fieldcat .

  ls_layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = l_repid
      is_layout          = ls_layout
      it_fieldcat        = gt_fieldcat
      is_print           = gs_print
    TABLES
      t_outtab           = gt_byuser
    EXCEPTIONS
      program_error      = 1.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM. "display_alv_by_user