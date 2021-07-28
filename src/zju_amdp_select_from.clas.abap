CLASS zju_amdp_select_from DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:
      BEGIN OF ty_result_line,
        carrier       TYPE /dmo/carrier_id,
        connection_id TYPE /dmo/connection_id,
      END OF ty_result_line,

      ty_result_table TYPE STANDARD TABLE OF ty_result_line WITH EMPTY KEY,
      ty_flights      TYPE STANDARD TABLE OF /dmo/flight.

* https://www.youtube.com/watch?v=_sdswDyEE-A
    METHODS select_from
      EXPORTING
                VALUE(result) TYPE ty_result_table
      RAISING   cx_amdp_execution_error.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zju_amdp_select_from IMPLEMENTATION.



  METHOD select_from BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight.
*             select *
*    result = select carrier_id as carrier, connection_id from "/DMO/FLIGHT"
*    where carrier_id = 'LH';

    result = select carrier_id as carrier, connection_id from "/DMO/FLIGHT"
      where carrier_id in ( 'LH', 'AZ' );
--    where carrier_id BETWEEN


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    TRY.

        me->select_from(
          IMPORTING
            result =  DATA(lt_result) ).

      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).


  ENDMETHOD.


ENDCLASS.
