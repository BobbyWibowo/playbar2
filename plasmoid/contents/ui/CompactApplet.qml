/*
 *   Author: audoban <audoban@openmailbox.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.4
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Flow{
	id: playbackControl

	spacing: units.smallSpacing / 2
	flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

	Layout.minimumWidth: !vertical ? playbackBar.width + playbackBar.buttonSize + spacing : units.iconSizes.small
	Layout.minimumHeight : vertical ? playbackBar.height + playbackBar.buttonSize + spacing : units.iconSizes.small
	anchors.fill: parent

	property int _buttonSize: vertical ? (parent && parent.width ? parent.width : 0 ): (parent && parent.height ? parent.height : 0 )

	property alias playbackBarVisible: playbackBar.visible

	PlaybackBar{
		id: playbackBar
		buttonSize: parent._buttonSize
	}
	Item{
		id: popupContainer
		width: _buttonSize
		height: _buttonSize
		PopupButton{
			id: popup

			size: playbackBar.visible ?
				_buttonSize * (plasmoid.configuration.FlatButtons ? 0.7 : 0.5) : _buttonSize
			anchors.centerIn: parent
			opened: plasmoid.expanded

			onClicked: {
				plasmoid.expanded = !plasmoid.expanded
			}
		}
	}


	Timer{
		//HACK: For PopupApplet in Notification
		running: playbackBar.visible
		interval: 100
		onTriggered: {
			if((!vertical && playbackBar.width > playbackControl.width) ||
				(vertical && playbackBar.height > playbackControl.height)){
				playbackBar.visible = false
			}

		}
	}

	MouseArea{
		id: volumeWheelArea
		acceptedButtons: Qt.XButton1 | Qt.XButton2
		z: 99
		parent: playbackBar.visible ? playbackBar : popupContainer
		anchors.fill: parent

		//HACK: Update volume when has occurred a change, and make more fluid the volume changes
		property real volumePrevious: mpris2.volume
		Connections{
			target: mpris2
			onVolumeChanged: volumeWheelArea.volumePrevious = mpris2.volume
		}

		onWheel: {
			wheel.accepted = true
			if(wheel.modifiers == Qt.NoModifier){
				if(wheel.angleDelta.y > 40)
					volumePrevious = mpris2.setVolume(volumePrevious + 0.05)
				else if(wheel.angleDelta.y < -40)
					volumePrevious = mpris2.setVolume(volumePrevious - 0.05)
			}
		}
	}
}
