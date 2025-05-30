import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import Shake from 'react-native-shake';
import verses from './verses.json';

export default function App() {
  const [verse, setVerse] = useState('Shake your phone to get a verse');

  const getRandomVerse = () => {
    const index = Math.floor(Math.random() * verses.length);
    return verses[index];
  };

  useEffect(() => {
    const subscription = Shake.addListener(() => {
      setVerse(getRandomVerse());
    });
    return () => {
      subscription.remove();
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.text}>{verse}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  text: {
    fontSize: 24,
    textAlign: 'center',
  },
});
