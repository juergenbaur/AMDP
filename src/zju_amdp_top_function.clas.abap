CLASS zju_amdp_top_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:

      BEGIN OF ty_aggregation_line,
        carrier_id    TYPE  /dmo/carrier_id,
        plane_type_id TYPE /dmo/plane_type_id,
        netto         TYPE /dmo/flight_price,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS execute_command
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_top_function IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        me->execute_command(
        IMPORTING
            result = DATA(lt_result) ).


      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).

  ENDMETHOD.


  METHOD execute_command BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight.

    result = select top 8 carrier_id, plane_type_id,
                    sum( price )  as netto
                   from "/DMO/FLIGHT"
                  GROUP BY carrier_id, plane_type_id
                  order by sum( price ) desc;

  ENDMETHOD.

ENDCLASS.
