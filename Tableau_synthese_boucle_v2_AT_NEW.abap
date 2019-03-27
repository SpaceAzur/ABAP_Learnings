*&---------------------------------------------------------------------*
*&  Include           ZTRAINING_FORMS
*&---------------------------------------------------------------------*



FORM get_data.

  SELECT a~matnr b~maktx a~pstat a~matkl a~mbrsh
    FROM mara AS a LEFT OUTER JOIN makt AS b
    ON a~matnr = b~matnr
    INTO CORRESPONDING FIELDS OF TABLE gt_material
    WHERE pstat IN so_pstat.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE text-002 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

FORM manage_data.

  LOOP AT gt_material INTO gs_material.
    CLEAR gs_cumul.
    READ TABLE gt_cumul INTO gs_cumul WITH KEY pstat = gs_material-pstat.
    IF sy-subrc = 0.
      gs_cumul-count = gs_cumul-count + 1.
      MODIFY gt_cumul FROM gs_cumul INDEX sy-tabix.
    ELSE.
      gs_cumul-pstat = gs_material-pstat.
      gs_cumul-count = gs_cumul-count + 1.
      APPEND gs_cumul TO gt_cumul.
    ENDIF.

  ENDLOOP.


ENDFORM.

FORM manage_data_2.

  SORT gt_material BY pstat.

* UTILISATION DE 'AT NEW'
* il faut impérativement que la table interne soit triée sur la colonne clé
* il faut impérativement que la clé soit le 1er champ de la table interne

  LOOP AT gt_material INTO gs_material.

    AT NEW pstat.
      CLEAR gs_cumul.
      gs_cumul-pstat = gs_material-pstat.
    ENDAT.
    gs_cumul-count = gs_cumul-count + 1.
    AT END OF pstat.
      APPEND gs_cumul TO gt_cumul.
    ENDAT.


  ENDLOOP.


ENDFORM.

*FORM display_data.
*
*  CLEAR gs_fieldcat .
*  gs_fieldcat-fieldname = ''.
*  gs_fieldcat-ref_tabname = 'MARA'.
*  gs_fieldcat-col_pos = 1.
*  APPEND gs_fieldcat  TO gt_fieldcat .
*
*  CLEAR gs_fieldcat .
*  gs_fieldcat-fieldname = 'MAKTX'.
*  gs_fieldcat-ref_tabname = 'MAKT'.
*  gs_fieldcat-col_pos = 2.
*  APPEND gs_fieldcat  TO gt_fieldcat .
*
*  CLEAR gs_fieldcat .
*  gs_fieldcat-fieldname = 'PSTAT'.
*  gs_fieldcat-ref_tabname = 'MARA '.
*  gs_fieldcat-col_pos = 3.
*  APPEND gs_fieldcat  TO gt_fieldcat .
*
*  ls_layout-zebra = 'X'.
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program = l_repid
*      is_layout          = ls_layout
*      it_fieldcat        = gt_fieldcat
*      is_print           = gs_print
*    TABLES
*      t_outtab           = gt_cumul
*    EXCEPTIONS
*      program_error      = 1.
*
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*ENDFORM.