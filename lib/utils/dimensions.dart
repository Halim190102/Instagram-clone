import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/screens/add_post_screen.dart';
import 'package:new_app/screens/feed_screen.dart';
import 'package:new_app/screens/profile_screen.dart';
import 'package:new_app/screens/search_screen.dart';

const webScreen = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
