

#ifndef   RB_SCOPE_FETCHING_HEADER
  #define   RB_SCOPE_FETCHING_HEADER

  #define 	DLL     extern __declspec(dllexport)
    
  typedef   
    struct fetch_helper
    fetch_hlp;
    
  typedef
    char*     (*buffer_address)(void*);
    
  typedef
    void      (*error_handler)(int);
  
  struct 
    fetch_helper
    {
	    char*				      address;        // physical address of the device
      error_handler     err_clbck;      // ruby callback to manage errors
      buffer_address    buffer_get;     // return the address of the next 
      void*             context;        // context for the buffer_address functions
      double            timeout;        // in sec; -1 = infinite     
      int               frm_siz;        // numbr of data points per one frame
      int               frm_tot;        // total number of frm to fetch, per channels all chans one acq
      int               frm_chk;        // numbr of frames to read in one packet (set by the buffer size)  
	    unsigned int	    session;        // (ViSession pointer id used by the niScope API)
    };
  
  DLL   int  fetch (fetch_hlp* parameters);

#endif


