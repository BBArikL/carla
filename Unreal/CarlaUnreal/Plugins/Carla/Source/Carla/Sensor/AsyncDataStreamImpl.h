// Copyright (c) 2024 Computer Vision Center (CVC) at the Universitat Autonoma
// de Barcelona (UAB).
//
// This work is licensed under the terms of the MIT license.
// For a copy, see <https://opensource.org/licenses/MIT>.

// Note: AsyncDataStream.h has a circular dependency with Game/CarlaEngine.h.
// You should not have to include this file directly (CarlaEngine.h includes it
// at the appropriate place.)

#pragma once

#include "Carla/Game/CarlaEngine.h"
#include "Carla/Sensor/AsyncDataStream.h"

template <typename T>
template <typename SensorT>
inline FAsyncDataStreamTmpl<T>::FAsyncDataStreamTmpl(
    const SensorT &Sensor,
    double Timestamp,
    StreamType InStream)
  : Stream(std::move(InStream)),
    Header([&Sensor, Timestamp]() {
      //check(IsInGameThread());
      using Serializer = carla::sensor::s11n::SensorHeaderSerializer;
      return Serializer::Serialize(
          carla::sensor::SensorRegistry::template get<SensorT*>::index,
          FCarlaEngine::GetFrameCounter(),
          Timestamp,
          Sensor.GetActorTransform());
    }()) {}
