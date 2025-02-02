// Copyright (c) 2024 Computer Vision Center (CVC) at the Universitat Autonoma
// de Barcelona (UAB).
//
// This work is licensed under the terms of the MIT license.
// For a copy, see <https://opensource.org/licenses/MIT>.

#pragma once

#include "CarlaRecorderHelpers.h"

#include <sstream>
#include <ctime>

struct CarlaRecorderInfo
{
  uint16_t Version;
  FString Magic;
  std::time_t Date;
  FString Mapfile;

  void Read(std::istream &File)
  {
    ReadValue<uint16_t>(File, Version);
    ReadFString(File, Magic);
    ReadValue<std::time_t>(File, Date);
    ReadFString(File, Mapfile);
  }

  void Write(std::ostream &File)
  {
    WriteValue<uint16_t>(File, Version);
    WriteFString(File, Magic);
    WriteValue<std::time_t>(File, Date);
    WriteFString(File, Mapfile);
  }
};
