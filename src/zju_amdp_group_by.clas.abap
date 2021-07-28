CLASS zju_amdp_group_by DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:

      BEGIN OF ty_aggregation_line,
        carrier_id TYPE  /dmo/carrier_id,
        plane_type_id  type /dmo/plane_type_id,
        netto      TYPE /dmo/flight_price,
        brutto     TYPE /dmo/flight_price,
        lowest     TYPE /dmo/flight_price,
        highest    TYPE /dmo/flight_price,
      END OF ty_aggregation_line,

      ty_aggregation_table TYPE STANDARD TABLE OF ty_aggregation_line WITH EMPTY KEY.


    METHODS group_by
      EXPORTING
                VALUE(result) TYPE ty_aggregation_table
      RAISING   cx_amdp_execution_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zju_amdp_group_by IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        me->group_by(
        IMPORTING
            result = DATA(lt_result) ).


      CATCH cx_amdp_execution_error INTO DATA(lx_amdp).
        out->write( lx_amdp->get_longtext( ) ).
    ENDTRY.

    out->write( lt_result ).

  ENDMETHOD.


  METHOD group_by BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY USING /dmo/flight.

            result = select carrier_id, plane_type_id,
                            sum( price )  as netto,
                            sum( price ) * 1.19 as brutto,
                            min( price ) as lowest,
                            max( price ) as highest
                           from "/DMO/FLIGHT"
--                          where carrier_id in ( 'LH', 'AZ' )
                          GROUP BY carrier_id, plane_type_id;

  ENDMETHOD.

ENDCLASS.
