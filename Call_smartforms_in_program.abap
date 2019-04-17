*&---------------------------------------------------------------------*
*&  Include           ZTRAINING_FORMS
*&---------------------------------------------------------------------*



FORM get_data
CHANGING ct_material TYPE ty_material_tab.

  SELECT a~matnr b~maktx a~pstat a~matkl a~mbrsh
    FROM mara AS a LEFT OUTER JOIN makt AS b
    ON a~matnr = b~matnr
    INTO CORRESPONDING FIELDS OF TABLE ct_material
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

FORM manage_data_2  USING     it_material TYPE ty_material_tab
                    CHANGING  ct_cumul    TYPE ty_cumul_tab.

  DATA : ls_material TYPE ty_material,
         ls_cumul    TYPE ty_cumul.

  SORT it_material BY pstat.

* UTILISATION DE 'AT NEW'
* il faut impérativement que la table interne soit triée sur la colonne clé
* il faut impérativement que la clé soit la 1ere colonne de la table interne

  LOOP AT it_material INTO ls_material.

    AT NEW pstat.
      CLEAR ls_cumul.
      ls_cumul-pstat = ls_material-pstat.
    ENDAT.
    ls_cumul-count = ls_cumul-count + 1.
    AT END OF pstat.
      APPEND ls_cumul TO ct_cumul.
    ENDAT.


  ENDLOOP.


ENDFORM.

FORM smartforms.


  DATA :  lv_form          TYPE tdsfname,
          lv_form1         TYPE tdsfname,
          lv_func          TYPE rs38l_fnam,
          lv_func1         TYPE rs38l_fnam,
          ls_control_param TYPE ssfctrlop,
          ls_composer_param TYPE ssfcompop,
          ls_output        TYPE ssfcompop,
          lv_count         TYPE i,
          lv_tabix         TYPE sy-tabix,
          lv_tri           TYPE string.

  lv_form = 'ZAESC_TRAINING_MARA'.
  lv_func = '/1BCDWB/SF00000089'.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_form
    IMPORTING
      fm_name            = lv_func
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CALL FUNCTION lv_func
    EXPORTING
      control_parameters = ls_control_param
      output_options     = ls_output
      user_settings      = ' '
*     gv_aire            = gs_aire-prvbe
*     gv_tri             = lv_tri
*     gv_nr              = p_num       "59141-ldeu-17/12/2018 _ modif3
      gt_cumul           = gt_cumul
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.