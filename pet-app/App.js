// App.js
import React, { useCallback } from 'react';
import { View } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import * as SplashScreen from 'expo-splash-screen';
import { useFonts } from 'expo-font';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

// Import หน้าจอที่เกี่ยวข้อง
import SplashScreenCustom from './screens/SplashScreen'; 
import SelectLoginScreen from './screens/SelectLogin';
import MemberStack from './navigator/MemberAppStack';
import SitterStack from './navigator/SitterAppStack';

SplashScreen.preventAutoHideAsync(); 

const RootStack = createNativeStackNavigator();

export default function App() {
  const [fontsLoaded] = useFonts({
    'Prompt-Medium': require('./assets/fonts/IBMPlexSansThai-Medium.ttf'),
    'Prompt-Regular': require('./assets/fonts/IBMPlexSansThai-Regular.ttf'),
    'Prompt-Bold': require('./assets/fonts/IBMPlexSansThai-Bold.ttf'),
    'Prompt-Light': require('./assets/fonts/IBMPlexSansThai-Light.ttf'),
  });

  const onLayoutRootView = useCallback(async () => {
    if (fontsLoaded) {
      await SplashScreen.hideAsync(); 
    }
  }, [fontsLoaded]);

  if (!fontsLoaded) {
    return null; 
  }

  return (
    <View style={{ flex: 1 }} onLayout={onLayoutRootView}>
      <NavigationContainer>
        <RootStack.Navigator
          initialRouteName="Splash"  
          screenOptions={{ headerShown: false }}
        >
          <RootStack.Screen
            name="Splash"
            component={SplashScreenCustom}
          />
          <RootStack.Screen name="SelectLogin" component={SelectLoginScreen} />
          <RootStack.Screen name="Member" component={MemberStack} />
          <RootStack.Screen name="Sitter" component={SitterStack} />
        </RootStack.Navigator>
      </NavigationContainer>
    </View>
  );
}
