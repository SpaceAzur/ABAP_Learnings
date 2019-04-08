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