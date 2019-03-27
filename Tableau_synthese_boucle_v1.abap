*&---------------------------------------------------------------------*
*&  Include           ZTRAINING_FORMS
*&---------------------------------------------------------------------*



FORM get_data.

  SELECT a~matnr b~maktx a~pstat a~matkl a~mbrsh
    FROM mara AS a LEFT OUTER JOIN makt AS b
    ON a~matnr = b~matnr
    INTO TABLE gt_material
    WHERE pstat IN so_pstat.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE text-002 type 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

FORM manage_data.
*
*  CLEAR gs_material.
*  SORT  gt_material BY pstat.
*  LOOP AT gt_material INTO gs_material.
*    gs_cumul-pstat = gs_material-pstat.
*    gs_cumul-count = 1.
*    COLLECT gs_cumul INTO gt_cumul.
*  ENDLOOP.

  loop at gt_material into gs_material.
    clear gs_cumul.
    READ TABLE gt_cumul into gs_cumul WITH key pstat = gs_material-pstat.
    if sy-subrc = 0.
      gs_cumul-count = gs_cumul-count + 1.
      modify gt_cumul from gs_cumul INDEX sy-tabix.
    else.
      gs_cumul-pstat = gs_material-pstat.
      gs_cumul-count = gs_cumul-count + 1.
      APPEND gs_cumul TO gt_cumul.
    ENDIF.

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