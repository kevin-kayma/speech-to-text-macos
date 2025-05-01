#pragma once

#include <flutter/flutter_engine.h>
#include <windows.h>

// Call this in main.cpp to register the MethodChannel
void RegisterWindowsIapChannel(flutter::FlutterEngine *engine, HWND window);
