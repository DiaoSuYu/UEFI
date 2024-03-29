<<BEGIN>><<SKIP>>
/** @file
  UEFI Driver Wizard template file

Copyright (c) 2012, Intel Corporation. All rights reserved.<BR>

This program and the accompanying materials are licensed and made 
available under the terms and conditions of the BSD License which 
accompanies this distribution.  The full text of the license may 
be found at http://opensource.org/licenses/bsd-license.php.

THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" 
BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER 
EXPRESS OR IMPLIED.

**/
<<END>>
/** @file
  <<BriefDescription>>
  
  <<DetailedDescription>>

  <<Copyright>>
  
  <<License>>

**/

#include "<<DriverName>>.h"

///
/// Driver Configuration Protocol instance
///
GLOBAL_REMOVE_IF_UNREFERENCED 
EFI_DRIVER_CONFIGURATION_PROTOCOL g<<DriverName>>DriverConfiguration = {
  (EFI_DRIVER_CONFIGURATION_SET_OPTIONS)   <<DriverName>>DriverConfigurationSetOptions,
  (EFI_DRIVER_CONFIGURATION_OPTIONS_VALID) <<DriverName>>DriverConfigurationOptionsValid,
  (EFI_DRIVER_CONFIGURATION_FORCE_DEFAULTS)<<DriverName>>DriverConfigurationForceDefaults,
  "<<Iso639SupportedLanguages>>"
};

///
/// Driver Configuration 2 Protocol instance
///
GLOBAL_REMOVE_IF_UNREFERENCED 
EFI_DRIVER_CONFIGURATION2_PROTOCOL g<<DriverName>>DriverConfiguration2 = {
  <<DriverName>>DriverConfigurationSetOptions,
  <<DriverName>>DriverConfigurationOptionsValid,
  <<DriverName>>DriverConfigurationForceDefaults,
  "<<Rfc4646SupportedLanguages>>"
};

/**
  Allows the user to set controller specific options for a controller that a 
  driver is currently managing.

  @param  This             A pointer to the EFI_DRIVER_CONFIGURATION_PROTOCOL instance.
  @param  ControllerHandle The handle of the controller to set options on.
  @param  ChildHandle      The handle of the child controller to set options on.  This
                           is an optional parameter that may be NULL.  It will be NULL
                           for device drivers, and for bus drivers that wish to set
                           options for the bus controller.  It will not be NULL for a
                           bus driver that wishes to set options for one of its child
                           controllers.
  @param  Language         A pointer to a three character ISO 639-2 language identifier.
                           This is the language of the user interface that should be
                           presented to the user, and it must match one of the languages
                           specified in SupportedLanguages.  The number of languages
                           supported by a driver is up to the driver writer.
  @param  ActionRequired   A pointer to the action that the calling agent is required
                           to perform when this function returns.  See "Related
                           Definitions" for a list of the actions that the calling
                           agent is required to perform prior to accessing
                           ControllerHandle again.

  @retval EFI_SUCCESS           The driver specified by This successfully set the
                                configuration options for the controller specified
                                by ControllerHandle..
  @retval EFI_INVALID_PARAMETER ControllerHandle is not a valid EFI_HANDLE.
  @retval EFI_INVALID_PARAMETER ChildHandle is not NULL and it is not a valid EFI_HANDLE.
  @retval EFI_INVALID_PARAMETER ActionRequired is NULL.
  @retval EFI_UNSUPPORTED       The driver specified by This does not support setting
                                configuration options for the controller specified by
                                ControllerHandle and ChildHandle.
  @retval EFI_UNSUPPORTED       The driver specified by This does not support the
                                language specified by Language.
  @retval EFI_DEVICE_ERROR      A device error occurred while attempt to set the
                                configuration options for the controller specified
                                by ControllerHandle and ChildHandle.
  @retval EFI_OUT_RESOURCES     There are not enough resources available to set the
                                configuration options for the controller specified
                                by ControllerHandle and ChildHandle.

**/
EFI_STATUS
EFIAPI
<<DriverName>>DriverConfigurationSetOptions (
  IN EFI_DRIVER_CONFIGURATION2_PROTOCOL                       *This,
  IN  EFI_HANDLE                                              ControllerHandle,
  IN  EFI_HANDLE                                              ChildHandle  OPTIONAL,
  IN  CHAR8                                                   *Language,
  OUT EFI_DRIVER_CONFIGURATION_ACTION_REQUIRED                *ActionRequired
  )
{
  return EFI_UNSUPPORTED;
}

/**
  Tests to see if a controller's current configuration options are valid.

  @param  This             A pointer to the EFI_DRIVER_CONFIGURATION_PROTOCOL instance.
  @param  ControllerHandle The handle of the controller to test if it's current
                           configuration options are valid.
  @param  ChildHandle      The handle of the child controller to test if it's current
                           configuration options are valid.  This is an optional
                           parameter that may be NULL.  It will be NULL for device
                           drivers.  It will also be NULL for bus drivers that wish
                           to test the configuration options for the bus controller.
                           It will not be NULL for a bus driver that wishes to test
                           configuration options for one of its child controllers.

  @retval EFI_SUCCESS           The controller specified by ControllerHandle and
                                ChildHandle that is being managed by the driver
                                specified by This has a valid set of  configuration
                                options.
  @retval EFI_INVALID_PARAMETER ControllerHandle is not a valid EFI_HANDLE.
  @retval EFI_INVALID_PARAMETER ChildHandle is not NULL and it is not a valid EFI_HANDLE.
  @retval EFI_UNSUPPORTED       The driver specified by This is not currently
                                managing the controller specified by ControllerHandle
                                and ChildHandle.
  @retval EFI_DEVICE_ERROR      The controller specified by ControllerHandle and
                                ChildHandle that is being managed by the driver
                                specified by This has an invalid set of configuration
                                options.

**/
EFI_STATUS
EFIAPI
<<DriverName>>DriverConfigurationOptionsValid (
  IN EFI_DRIVER_CONFIGURATION2_PROTOCOL                       *This,
  IN  EFI_HANDLE                                              ControllerHandle,
  IN  EFI_HANDLE                                              ChildHandle  OPTIONAL
  )
{
  return EFI_UNSUPPORTED;
}  

/**
  Forces a driver to set the default configuration options for a controller.

  @param  This             A pointer to the EFI_DRIVER_CONFIGURATION_PROTOCOL instance.
  @param  ControllerHandle The handle of the controller to force default configuration options on.
  @param  ChildHandle      The handle of the child controller to force default configuration options on  This is an optional parameter that may be NULL.  It will be NULL for device drivers.  It will also be NULL for bus drivers that wish to force default configuration options for the bus controller.  It will not be NULL for a bus driver that wishes to force default configuration options for one of its child controllers.
  @param  DefaultType      The type of default configuration options to force on the controller specified by ControllerHandle and ChildHandle.  See Table 9-1 for legal values.  A DefaultType of 0x00000000 must be supported by this protocol.
  @param  ActionRequired   A pointer to the action that the calling agent is required to perform when this function returns.  See "Related Definitions" in Section 9.1 for a list of the actions that the calling agent is required to perform prior to accessing ControllerHandle again.

  @retval EFI_SUCCESS           The driver specified by This successfully forced the default configuration options on the controller specified by ControllerHandle and ChildHandle.
  @retval EFI_INVALID_PARAMETER ControllerHandle is not a valid EFI_HANDLE.
  @retval EFI_INVALID_PARAMETER ChildHandle is not NULL and it is not a valid EFI_HANDLE.
  @retval EFI_INVALID_PARAMETER ActionRequired is NULL.
  @retval EFI_UNSUPPORTED       The driver specified by This does not support forcing the default configuration options on the controller specified by ControllerHandle and ChildHandle.
  @retval EFI_UNSUPPORTED       The driver specified by This does not support the configuration type specified by DefaultType.
  @retval EFI_DEVICE_ERROR      A device error occurred while attempt to force the default configuration options on the controller specified by  ControllerHandle and ChildHandle.
  @retval EFI_OUT_RESOURCES     There are not enough resources available to force the default configuration options on the controller specified by ControllerHandle and ChildHandle.

**/
EFI_STATUS
EFIAPI
<<DriverName>>DriverConfigurationForceDefaults (
  IN EFI_DRIVER_CONFIGURATION2_PROTOCOL                       *This,
  IN  EFI_HANDLE                                              ControllerHandle,
  IN  EFI_HANDLE                                              ChildHandle  OPTIONAL,
  IN  UINT32                                                  DefaultType,
  OUT EFI_DRIVER_CONFIGURATION_ACTION_REQUIRED                *ActionRequired
  )
{
  return EFI_UNSUPPORTED;
}
