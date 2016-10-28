/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  Dimensions,
  View,
  TouchableHighlight,
  Modal
} from 'react-native';

var {
  VideoMergeUtil
} = require('NativeModules');

import Camera from 'react-native-camera';
import Video from 'react-native-video';


export default class RCTVideoEditor extends Component {

  constructor(props) {
    super(props);

    this.state = {
      videos: [],
      mergedVideo: '',
      cameraModal: false,
      isRecording: false,
      videoModal: false,
    };
  }

  merge() {
    //alert(this.state.videos)
    VideoMergeUtil.merge(
        this.state.videos,
        function errorCallback(results) {
            alert('Error: ' + results);
        },
        (results, file) => {
            //alert('Success : ' + results + " " +file);
            this.setState({mergedVideo: file, videoModal: true});
        }
    );
  }

  takePicture() {
    if(!this.state.isRecording) {
      this.camera.capture()
        .then((data) => {
          this.setState({videos: [...this.state.videos, data.path]})
        })
        .catch(err => console.error(err));
      this.setState({isRecording: true});
    } else {
    this.camera.stopCapture()
    this.setState({isRecording: false, cameraModal: false});
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableHighlight onPress={() => this.setState({cameraModal: true})}><Text>Open camera</Text></TouchableHighlight>
        <TouchableHighlight onPress={() => this.merge()}><Text>MERGE</Text></TouchableHighlight>
        <Modal
          animationType={"slide"}
          transparent={false}
          visible={this.state.cameraModal}
          onRequestClose={() => {alert("Modal has been closed.")}}
          >
          <Camera
            ref={(cam) => {
              this.camera = cam;
            }}
            captureTarget={Camera.constants.CaptureTarget.disk}
            orientation={Camera.constants.Orientation.portrait}
            captureMode={Camera.constants.CaptureMode.video}
            style={styles.preview}
            aspect={Camera.constants.Aspect.fill}>
            <Text style={styles.capture} onPress={this.takePicture.bind(this)}>[CAPTURE]</Text>
          </Camera>
        </Modal>



         <Modal
           animationType={"slide"}
           transparent={false}
           visible={this.state.videoModal}
           onRequestClose={() => {alert("Modal has been closed.")}}
           >
           <Video source={{uri: this.state.mergedVideo}}   // Can be a URL or a local file.
            rate={1.0}                     // 0 is paused, 1 is normal.
            volume={1.0}                   // 0 is muted, 1 is normal.
            muted={false}                  // Mutes the audio entirely.
            paused={false}                 // Pauses playback entirely.
            resizeMode="cover"             // Fill the whole screen at aspect ratio.
            repeat={true}                  // Repeat forever.
            style={{width:200, height:200}} />
         </Modal>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  preview: {
    flex: 1,
    justifyContent: 'flex-end',
    alignItems: 'center',
    height: Dimensions.get('window').height,
    width: Dimensions.get('window').width
  },
  capture: {
    flex: 0,
    backgroundColor: '#fff',
    borderRadius: 5,
    color: '#000',
    padding: 10,
    margin: 40
  }
});

AppRegistry.registerComponent('RCTVideoEditor', () => RCTVideoEditor);
