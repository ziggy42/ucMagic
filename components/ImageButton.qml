/*
 * Copyright (C) 2013 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Nekhelesh Ramananthan <krnekhelesh@gmail.com>
 */

/*
 * This file is taken from ubuntu-clock-app, see <http://bazaar.launchpad.net/~ubuntu-clock-dev/ubuntu-clock-app/trunk/view/head:/common/ImageButton.qml>
 */

import QtQuick 2.0
import Ubuntu.Components 0.1

// Qml Item to draw a button with an image on its left/right
AbstractButton {
    id: imageButton

    // Set the button label and image
    property alias buttonLabel: label.text;
    property alias buttonImage: image.source;

    // Property to mirror the button layout if necessary. Image on the left by default.
    property bool mirrorLayout: false;

    width: childrenRect.width; height: childrenRect.height;    

    Row {
        spacing: units.gu(1);
        //height: childrenRect.height;
        //LayoutMirroring.enabled: mirrorLayout

        Image {
            id: image
            source: "file"
            height: imageButton.height
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: label
            fontSize: "large"            
            anchors.verticalCenter: image.verticalCenter
            color: Theme.palette.normal.baseText;
        }
    }
}
