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
  base: "#ffffff"
  alternateBase: "#dfdfdf"
  window: "#f0f0f0"
  toolTipBase: "#eeeeff"
  // Accent colors
  highlight: "#007dd7"
  link: "#0000ff"
  linkVisited: "#ff00ff"
  // Various tones of white, from lighter to darker as per documentation
  light: "#ffffff"
  midlight: "#bfbfbf"
  button: "#afafaf"
  mid: "#9f9f9f"
  dark: "#8f8f8f"
  shadow: "#6f6f6f"
  // Foreground (primarily, text) colors
  text: "#000000"
  highlightedText: "#ffffff"
  windowText: "#000000"
  buttonText: "#000000"
  toolTipText: "#000000"
  brightText: "#ffffff"
  placeholderText: "#80000000"

  active {
    // Background colors
    base: "#ffffff"
    alternateBase: "#dfdfdf"
    window: "#f0f0f0"
    toolTipBase: "#eeeeff"
    // Accent colors
    highlight: "#007dd7"
    link: "#0000ff"
    linkVisited: "#ff00ff"
    // Various tones of white, from lighter to darker as per documentation
    light: "#ffffff"
    midlight: "#bfbfbf"
    button: "#afafaf"
    mid: "#9f9f9f"
    dark: "#8f8f8f"
    shadow: "#6f6f6f"
    // Foreground (primarily, text) colors
    text: "#000000"
    highlightedText: "#ffffff"
    windowText: "#000000"
    buttonText: "#000000"
    toolTipText: "#000000"
    brightText: "#ffffff"
    placeholderText: "#80000000"
  }

  inactive {
    // Background colors
    base: "#ffffff"
    alternateBase: "#dfdfdf"
    window: "#f0f0f0"
    toolTipBase: "#eeeeff"
    // Accent colors
    highlight: "#f0f0f0"
    link: "#0000ff"
    linkVisited: "#ff00ff"
    // Various tones of white, from lighter to darker as per documentation
    light: "#ffffff"
    midlight: "#bfbfbf"
    button: "#afafaf"
    mid: "#9f9f9f"
    dark: "#8f8f8f"
    shadow: "#6f6f6f"
    // Foreground (primarily, text) colors
    text: "#000000"
    highlightedText: "#000000"
    windowText: "#000000"
    buttonText: "#000000"
    toolTipText: "#000000"
    brightText: "#ffffff"
    placeholderText: "#80000000"
  }

  disabled {
    // Background colors
    base: "#f0f0f0"
    alternateBase: "#d0d0d0"
    window: "#f0f0f0"
    toolTipBase: "#eeeeff"
    // Accent colors
    highlight: "#007dd7"
    link: "#0000ff"
    linkVisited: "#ff00ff"
    // Various tones of white, from lighter to darker as per documentation
    light: "#ffffff"
    midlight: "#dfdfdf"
    button: "#afafaf"
    mid: "#9f9f9f"
    dark: "#8f8f8f"
    shadow: "#000000"
    // Foreground (primarily, text) colors
    text: "#6f6f6f"
    highlightedText: "#ffffff"
    windowText: "#6f6f6f"
    buttonText: "#6f6f6f"
    toolTipText: "#000000"
    brightText: "#ffffff"
    placeholderText: "#80000000"
  }
}
