/*
 *   This file has been automatically generated
 *   by ni_scope/api/builder.rb
 *
 *   software: ni_scope gem
 *   author: hugo benichi
 *   contact: hugo.benichi@m4x.org
 *
 */

#include "niScope.h"

#define DLL extern __declspec(dllexport)

DLL int rbScope_init(char* arg1, unsigned short arg2, unsigned short arg3, ViUInt32* arg4)
{
  return niScope_init(arg1, arg2, arg3, arg4);
}

DLL int rbScope_close(unsigned int arg1)
{
  return niScope_close(arg1);
}

DLL int rbScope_CalSelfCalibrate(unsigned int arg1, char* arg2, int arg3)
{
  return niScope_CalSelfCalibrate(arg1, arg2, arg3);
}

DLL int rbScope_ConfigureAcquisition(unsigned int arg1, int arg2)
{
  return niScope_ConfigureAcquisition(arg1, arg2);
}

DLL int rbScope_ConfigureTriggerDigital(unsigned int arg1, char* arg2, int arg3, double arg4, double arg5)
{
  return niScope_ConfigureTriggerDigital(arg1, arg2, arg3, arg4, arg5);
}

DLL int rbScope_ConfigureTriggerEdge(unsigned int arg1, char* arg2, double arg3, int arg4, int arg5, double arg6, double arg7)
{
  return niScope_ConfigureTriggerEdge(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
}

DLL int rbScope_ConfigureTriggerImmediate(unsigned int arg1)
{
  return niScope_ConfigureTriggerImmediate(arg1);
}

DLL int rbScope_ConfigureChanCharacteristics(unsigned int arg1, char* arg2, double arg3, double arg4)
{
  return niScope_ConfigureChanCharacteristics(arg1, arg2, arg3, arg4);
}

DLL int rbScope_ConfigureVertical(unsigned int arg1, char* arg2, double arg3, double arg4, int arg5, double arg6, unsigned short arg7)
{
  return niScope_ConfigureVertical(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
}

DLL int rbScope_ConfigureHorizontalTiming(unsigned int arg1, double arg2, int arg3, double arg4, int arg5, unsigned short arg6)
{
  return niScope_ConfigureHorizontalTiming(arg1, arg2, arg3, arg4, arg5, arg6);
}

DLL int rbScope_ActualRecordLength(unsigned int arg1, ViInt32* arg2)
{
  return niScope_ActualRecordLength(arg1, arg2);
}

DLL int rbScope_ActualNumWfms(unsigned int arg1, char* arg2, ViInt32* arg3)
{
  return niScope_ActualNumWfms(arg1, arg2, arg3);
}

DLL int rbScope_GetAttributeViBoolean(unsigned int arg1, char* arg2, unsigned int arg3, unsigned short* arg4)
{
  return niScope_GetAttributeViBoolean(arg1, arg2, arg3, arg4);
}

DLL int rbScope_GetAttributeViInt32(unsigned int arg1, char* arg2, unsigned int arg3, ViInt32* arg4)
{
  return niScope_GetAttributeViInt32(arg1, arg2, arg3, arg4);
}

DLL int rbScope_GetAttributeViReal64(unsigned int arg1, char* arg2, unsigned int arg3, double* arg4)
{
  return niScope_GetAttributeViReal64(arg1, arg2, arg3, arg4);
}

DLL int rbScope_GetAttributeViString(unsigned int arg1, char* arg2, unsigned int arg3, int arg4, char* arg5)
{
  return niScope_GetAttributeViString(arg1, arg2, arg3, arg4, arg5);
}

DLL int rbScope_SetAttributeViBoolean(unsigned int arg1, char* arg2, unsigned int arg3, unsigned short arg4)
{
  return niScope_SetAttributeViBoolean(arg1, arg2, arg3, arg4);
}

DLL int rbScope_SetAttributeViInt32(unsigned int arg1, char* arg2, unsigned int arg3, int arg4)
{
  return niScope_SetAttributeViInt32(arg1, arg2, arg3, arg4);
}

DLL int rbScope_SetAttributeViReal64(unsigned int arg1, char* arg2, unsigned int arg3, double arg4)
{
  return niScope_SetAttributeViReal64(arg1, arg2, arg3, arg4);
}

DLL int rbScope_SetAttributeViString(unsigned int arg1, char* arg2, unsigned int arg3, char* arg4)
{
  return niScope_SetAttributeViString(arg1, arg2, arg3, arg4);
}

DLL int rbScope_errorHandler(unsigned int arg1, int arg2, char* arg3, char* arg4)
{
  return niScope_errorHandler(arg1, arg2, arg3, arg4);
}

DLL int rbScope_GetError(unsigned int arg1, ViInt32* arg2, int arg3, char* arg4)
{
  return niScope_GetError(arg1, arg2, arg3, arg4);
}

DLL int rbScope_GetErrorMessage(unsigned int arg1, int arg2, int arg3, char* arg4)
{
  return niScope_GetErrorMessage(arg1, arg2, arg3, arg4);
}

DLL int rbScope_InitiateAcquisition(unsigned int arg1)
{
  return niScope_InitiateAcquisition(arg1);
}

DLL int rbScope_AcquisitionStatus(unsigned int arg1, ViInt32* arg2)
{
  return niScope_AcquisitionStatus(arg1, arg2);
}

DLL int rbScope_FetchBinary8(unsigned int arg1, char* arg2, double arg3, int arg4, char* arg5, void* arg6)
{
  return niScope_FetchBinary8(arg1, arg2, arg3, arg4, arg5, arg6);
}

DLL int rbScope_FetchBinary16(unsigned int arg1, char* arg2, double arg3, int arg4, short* arg5, void* arg6)
{
  return niScope_FetchBinary16(arg1, arg2, arg3, arg4, arg5, arg6);
}

DLL int rbScope_Abort(unsigned int arg1)
{
  return niScope_Abort(arg1);
}

