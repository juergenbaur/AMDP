CLASS zju_amdp_aggregate_functions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:

      BEGIN OF ty_aggregation_line,
        netto  TYPE /dmo/flight_price,
        brutto TYPE /dmo/flight_price,
        lowest type /dmo/flight_price,
        highest type /dmo/flight_price,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS aggregation_functions
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_aggregate_functions IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        me->aggregation_functions(
        IMPORTING
            result = DATA(lt_result) ).


      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).

  ENDMETHOD.


  METHOD aggregation_functions BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight.

    --    price = select '0' from dummy.
    --    declare price "$ABAP.type( /dmo/flight_price )";
            result = select sum( price )  as netto,
                            sum( price ) * 1.19 as brutto,
                            min( price ) as lowest,
                            max( price ) as highest
                           from "/DMO/FLIGHT"
                          where carrier_id in ( 'LH', 'AZ' );

  ENDMETHOD.

ENDCLASS.
