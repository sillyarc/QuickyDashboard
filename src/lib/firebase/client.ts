import { FirebaseApp, getApp, getApps, initializeApp } from "firebase/app";
import { Auth, getAuth } from "firebase/auth";
import { Firestore, getFirestore } from "firebase/firestore";
import { Functions, getFunctions } from "firebase/functions";

const firebaseConfig = {
  apiKey:
    process.env.NEXT_PUBLIC_FIREBASE_API_KEY ??
    "AIzaSyCxq0iBKdwc2F7SdBnYCzMhC-nXIMIEyyU",
  authDomain:
    process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN ??
    "quick-b108e.firebaseapp.com",
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID ?? "quick-b108e",
  storageBucket:
    process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET ??
    "quick-b108e.firebasestorage.app",
  messagingSenderId:
    process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID ?? "1075126726259",
  appId:
    process.env.NEXT_PUBLIC_FIREBASE_APP_ID ??
    "1:1075126726259:web:0d395f965fa14a0bc68406",
  measurementId:
    process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID ?? "G-D8P4TB2KJP",
};

let firebaseApp: FirebaseApp | null = null;

export const getFirebaseApp = (): FirebaseApp => {
  if (firebaseApp) return firebaseApp;
  firebaseApp = getApps().length ? getApp() : initializeApp(firebaseConfig);
  return firebaseApp;
};

export const getFirebaseDb = (): Firestore => getFirestore(getFirebaseApp());

export const getFirebaseAuth = (): Auth | null => {
  if (typeof window === "undefined") return null;
  return getAuth(getFirebaseApp());
};

export const getFirebaseFunctions = (): Functions => getFunctions(getFirebaseApp());
