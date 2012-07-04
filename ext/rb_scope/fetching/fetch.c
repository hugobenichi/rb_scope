
#include  <stdio.h>
#include  <stdlib.h>
#include  "fetch.h"
#include 	"niScope.h" 

#define   prompt(MSG, ...)    printf("RbScope::Fetching::fetch.c >> " MSG, __VA_ARGS__)

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
  
  char*           buff0     = NULL;
  char*           buff1     = NULL;
  buffer_address  buf_chan0 = parameters-> chan0;
  buffer_address  buf_chan1 = parameters-> chan1;
  void*           context0  = parameters-> chan0_context;
  void*           context1  = parameters-> chan1_context;
  error_handler   err_clbck = parameters-> err_clbck;
   
  wfm_info  frm_inf;
  wfm_info *frm_inf_p = &frm_inf;
 
  int i, rez, records_done;  

  rez = niScope_SetAttributeViBoolean(session, VI_NULL, NISCOPE_ATTR_ALLOW_MORE_RECORDS_THAN_MEMORY, 1); // maybe have to move this before horizontal configuration
  if( rez < 0) err_clbck(rez);
  rez = niScope_SetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_HORZ_RECORD_LENGTH,  frm_siz);
  if( rez < 0) err_clbck(rez);
  rez = niScope_SetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_HORZ_NUM_RECORDS,    frm_tot);
  if( rez < 0) err_clbck(rez);
  rez = niScope_SetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_FETCH_NUM_RECORDS,   frm_chk);
  if( rez < 0) err_clbck(rez);

  prompt("starting fetching on %s\n", address);  
  for (i = 0; i < frm_tot; i += frm_chk) 
  {
    
    rez = niScope_SetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_FETCH_RECORD_NUMBER, i);    
    
    if( rez < 0) err_clbck(rez);
    if (buf_chan0 && (buff0 = buf_chan0(context0)) )   /* this call can block ! */
      rez = niScope_FetchBinary8(session, "0", timeout, frm_siz, buff0, frm_inf_p);  
      
    if( rez < 0) err_clbck(rez);
    if (buf_chan1 && (buff1 = buf_chan1(context1)) )    /* this call can block ! */
      rez = niScope_FetchBinary8(session, "1", timeout, frm_siz, buff1, frm_inf_p);      
           
    if( rez < 0) err_clbck(rez);
    
    rez = niScope_GetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_RECORDS_DONE, &records_done);    
    if( rez < 0) err_clbck(rez);
    prompt("%s, frames fetched #%i  |  measured #%i  |  left %i\n", address, i, records_done, records_done - i);
  }

  rez = niScope_GetAttributeViInt32(session, VI_NULL, NISCOPE_ATTR_RECORDS_DONE, &records_done);
  if( rez < 0) err_clbck(rez);
  
  prompt("%s, total frames measured per channel: %i\n", address, records_done);
  
  return records_done;
  
}