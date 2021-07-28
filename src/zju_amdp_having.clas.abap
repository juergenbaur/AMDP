CLASS zju_amdp_having DEFINITION
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
        currency_code TYPE /dmo/currency_code,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS having
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_having IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        me->having(
        IMPORTING
            result = DATA(lt_result) ).


      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).

  ENDMETHOD.


  METHOD having BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight.

    result = select carrier_id, plane_type_id,
                    sum( price )  as netto,
                   currency_code
                   from "/DMO/FLIGHT"
                  GROUP BY carrier_id, plane_type_id, currency_code
                  having sum( price ) > 8000
                  order by carrier_id;

  ENDMETHOD.

ENDCLASS.
