// Copyright (C) 2024 Mikhail Dryuchin <cstddef@gmail.com>
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>. 

import QtQuick


Palette {
  // Background colors
  base: "#3f3f3f"
  alternateBase: "#7f7f7f"
  window: "#4f4f4f"
  toolTipBase: "#6f6f6f"
  // Accent colors
  highlight: "#00d77d"
  link: "#0000ff"
  linkVisited: "#ff00ff"
  // Various tones of white, from lighter to darker as per documentation
  light: "#ffffff"
  midlight: "#bfbfbf"
  button: "#2f2f2f"
  mid: "#a0a0a0"
  dark: "#505050"
  shadow: "#303030"
  // Foreground (primarily, text) colors
  text: "#ffffff"
  highlightedText: "#000000"
  windowText: "#ffffff"
  buttonText: "#ffffff"
  toolTipText: "#ffffff"
  brightText: "#ffffff"
  placeholderText: "#80ffffff"

  active {
    // Background colors
    base: "#3f3f3f"
    alternateBase: "#7f7f7f"
    window: "#4f4f4f"
    toolTipBase: "#6f6f6f"
    // Accent colors
    highlight: "#00d77d"
    link: "#0000ff"
    linkVisited: "#ff00ff"
    // Various tones of white, from lighter to darker as per documentation
    light: "#ffffff"
    midlight: "#bfbfbf"
    button: "#6f6f6f"
    mid: "#a0a0a0"
    dark: "#505050"
    shadow: "#303030"
    // Foreground (primarily, text) colors
    text: "#ffffff"
    highlightedText: "#000000"
    windowText: "#ffffff"
    buttonText: "#ffffff"
    toolTipText: "#ffffff"
    brightText: "#ffffff"
    placeholderText: "#80ffffff"
  }

  inactive {
    // Background colors
    base: "#3f3f3f"
    alternateBase: "#7f7f7f"
    window: "#4f4f4f"
    toolTipBase: "#6f6f6f"
    // Accent colors
    highlight: "#f0f0f0"
    link: "#0000ff"
    linkVisited: "#ff00ff"
    // Various tones of white, from lighter to darker as per documentation
    light: "#ffffff"
    midlight: "#bfbfbf"
    button: "#2f2f2f"
    mid: "#a0a0a0"
    dark: "#505050"
    shadow: "#303030"
    // Foreground (primarily, text) colors
    text: "#ffffff"
    highlightedText: "#000000"
    windowText: "#ffffff"
    buttonText: "#ffffff"
    toolTipText: "#ffffff"
    brightText: "#ffffff"
    placeholderText: "#80ffffff"
  }

  disabled {
    // Background colors
    base: "#6f6f6f"
    alternateBase: "#afafaf"
    window: "#4f4f4f"
    toolTipBase: "#6f6f6f"
    // Accent colors
    highlight: "#00d77d"
    link: "#0000ff"
    linkVisited: "#ff00ff"
    // Various tones of white, from lighter to darker as per documentation
    light: "#ffffff"
    midlight: "#ffffff"
    button: "#6f6f6f"
    mid: "#a0a0a0"
    dark: "#505050"
    shadow: "#000000"
    // Foreground (primarily, text) colors
    text: "#afafaf"
    highlightedText: "#2f2f2f"
    windowText: "#afafaf"
    buttonText: "#afafaf"
    toolTipText: "#ffffff"
    brightText: "#ffffff"
    placeholderText: "#80ffffff"
  }
}
