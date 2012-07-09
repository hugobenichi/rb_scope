#include  <stdio.h>
#include  <stdlib.h>
#include  "fetch.h"
#include 	"niScope.h" 


#define   prompt(MSG, ...)    printf("RbScope::Fetching >> " MSG, __VA_ARGS__)


  typedef   
    struct niScope_wfmInfo 
    wfm_info;
    
  
DLL int fetch(
    fetch_hlp* parameters
  )
{
    
  unsigned int    session   = parameters-> session;
  char*           address   = parameters-> address;
  int             frm_siz   = parameters-> frm_siz;
  int             frm_tot   = parameters-> frm_tot;
  int             frm_chk   = parameters-> frm_chk;
  double          timeout   = parameters-> timeout;
  
  char*           buf       = NULL;
  buffer_address  buf_get   = parameters-> buffer_get;
  void*           context   = parameters-> context;
  error_handler   err_clbck = parameters-> err_clbck;
   
  #define err_check(ret_code)  do {\
                                  int err_check_local_err_code = ret_code;\
                                  if( err_check_local_err_code < 0)\
                                  {\
                                    if (err_clbck)\
                                      err_clbck( err_check_local_err_code );\
                                    prompt( "early return from error\n");\
                                    niScope_Abort(session);\
                                    return -1;\
                                  }\
                                } while (0)
                                
  wfm_info *frm_inf_p = malloc( sizeof(wfm_info) * 2 * frm_chk );
  char* loc_buffer = malloc( 2 * frm_chk * frm_siz * sizeof(char)  ); 

  int i, rez, records_done;  
  
  prompt("starting fetching on %s\n record length %i  |  record tot num %i  |  chunk %i\n", address, frm_siz, frm_tot, frm_chk);  
  for (i = 0; i < frm_tot; i += frm_chk) 
  { 
    err_check( niScope_SetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_FETCH_RECORD_NUMBER, i) );
    if (buf_get && !(buf = buf_get(context)) ) buf = loc_buffer;
    err_check( niScope_FetchBinary8(session, "0,1", timeout, frm_siz, buf, frm_inf_p) );
    err_check( niScope_GetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_RECORDS_DONE, &records_done) );
    prompt("%s, frames fetched #%i | measured #%i | in dev mem %i\n", address, i, records_done, records_done - i);
  }
  
  free(loc_buffer);
  
  return records_done;
  
  #undef err_check
  
}


#undef prompt