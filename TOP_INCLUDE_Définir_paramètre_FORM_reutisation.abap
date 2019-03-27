*&---------------------------------------------------------------------*
*& Include ZTRAINING_TOP                                     Report Z_TRAINING_COMPTA
*&
*&---------------------------------------------------------------------*

TABLES : mara, makt.

type-POOLs slis.

TYPES: BEGIN OF ty_material,
            pstat TYPE mara-pstat,
            matnr TYPE mara-matnr,
            maktx TYPE makt-maktx,
            matkl TYPE mara-matkl,
            mbrsh TYPE mara-mbrsh,
       END OF ty_material,
       ty_material_tab TYPE TABLE OF ty_material.

TYPES: BEGIN OF ty_cumul,
            pstat TYPE mara-pstat,
            count TYPE i,
       END OF ty_cumul,
       ty_cumul_tab TYPE TABLE OF ty_cumul.

TYPES: BEGIN OF slis_print_alv.
        INCLUDE TYPE alv_s_prnt.
        INCLUDE TYPE slis_print_alv1.
TYPES: END OF slis_print_alv.

DATA :  gt_material TYPE ty_material_tab,
        gs_material TYPE ty_material,
        gt_cumul     TYPE ty_cumul_tab,
        gs_cumul     TYPE ty_cumul.

DATA :  gs_fieldcat TYPE slis_fieldcat_alv,
        ls_layout   TYPE slis_layout_alv,
        l_repid     LIKE sy-repid,
        gt_fieldcat TYPE slis_t_fieldcat_alv,
        gs_print    TYPE slis_print_alv.