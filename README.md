# SendFuuds

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)
1. [Walkthrough](#Walkthrough)
1. [App Pitch Presentation](#App-Pitch-Presentation)
1. [Authors](#Authors)

## Overview

### App Description
Have you ever had food that you couldn't finish, and just ended up throwing it away? Chances are, you have. 

**JJDProductions** aims to solve this great problem in the world today with **SendFuuds**.

**SendFuuds** is an application where users can get notified that their food is about to expire and are given an option to share it with friends.

Uses [Parse](https://docs.parseplatform.org/parse-server/guide/) for storing data. 

### App Evaluation
- **Category:** Social Media/Personal use
- **Mobile:** This app would be primarily developed for iOS users and will work similar to apps like [Instagram](https://www.instagram.com/?hl=en).
- **Story:** Analyzes users music choices, and connects them to other users with similar choices. The user can then decide to message this person and befriend them if wanted.
- **Market:** Any individual could choose to use this app. We all need to be aware of the food that we waste each day!
- **Habit:** This app could be used more often by people who cook to ensure that the groceries they buy do not expire. 
- **Scope:** We will start by having users around UC Irvine use the application, but we expect that this application can be used by people around the world.

## Product Spec

### User Stories

**Required Must-have Stories**
- [x] User can log in
- [x] User can sign up
- [x] User stays logged in across restarts.
- [x] User can log out.
- [x] User can enter correct login/sign up credentials
- [x] User can enter the expiration date of their groceries and post it to a home feed.
- [x] User has the option to post an image from their photo gallery or camera. 
- [x] User can search and add friends.
- [x] User can only see his own posts and his friends' posts on the home feed.
- [x] User gets notified when their food is about to expire.
- [ ] User can remove their own posts.
- [ ] User can notify friends about getting or sharing their soon-to-expire food.
- [ ] User can see recent notifications in a page on the application. 
- [ ] Once a food is expired, User is no longer be able to see the food on their home feed. 

**Optional Nice-to-have Stories**
- [ ] User can chat with other users.
- [ ] User can click the image of a post which would send the poster a notification saying that the user is interested in their food. 
- [ ] User can have their own personal feed with their food and once the food is about to expire, the user is asked whether or not they want to share their food with others. 
- [ ] At the end of each month, show how much food was wasted.
- [ ] Users have a profile page
- [ ] Users can see mutual friends.
- [ ] Users can share on other social media, such as Instagram or Facebook.
- [ ] Users can livestream themselves eating.
- [ ] Users can filter out searches for specific food.

### App Screen Archetypes

 * Login Screen
     * User can login
     * User can create a new account
 * Stream (Home Screen)
     * User can view a feed of their own food and their friends' food.
 * Creation (Post Screen)
     * User can post a new food to their feed, add the expiration date, and a brief description.
 * Search Screen
     * User can search for other users
     * User can add another user
 * Send Request Screen
     * User can ask friends if they want their soon-to-expire food.
 * Notification Screen
     * User can see recent notifications that they have received.

### App Navigation Flows

**Tab Navigation**

 * Home Feed
 * Search User
 * Post a Food
 * Send request
 * Notification 

**Flow Navigation**

 * Login Screen
    => Home after logging in or signing up.
 * Stream (Home Screen)
    => Login Screen by clicking the Logout button.
    => Future version might involve navigation to a profile page for a user.
    => Any other screen by clicking one of them on the tab bar.
    => Login screen by clicking logout.
 * Creation (Post Screen)
    => Home after a user posts their food.
    => Any other screen by clicking one of them on the tab bar.
    => Login screen by clicking logout.
 * Search Screen.
    => Any other screen by clicking one of them on the tab bar.
    => Login screen by clicking logout.
 * Send Request Screen
    => Home after sending a request.
    => Any other screen by clicking one of them on the tab bar.
    => Login screen by clicking logout.
 * Notification Screen
    => Any other screen by clicking one of them on the tab bar.
    => Login screen by clicking logout.
    
## Wireframes

**Hand-Drawn:**


**Digital:**
https://www.figma.com/proto/BNQyBUMhIxUdroJeTUbXtPLb/SendFuuds?node-id=0%3A1&scaling=scale-down

<img src='https://i.imgur.com/ZKQlv1m.gif' title='Wireframe Walkthrough' width='' alt='Wireframe Walkthrough' />

### Schema 
### Models

    
### Walkthrough

## Walkthrough of the following user stories: 

- [x] User can log in
- [x] User can sign up
- [x] User stays logged in across restarts.
- [x] User can log out.
- [x] User can enter correct login/sign up credentials
- [x] User can enter the expiration date of their groceries and post it to a home feed.
- [x] User has the option to post an image from their photo gallery or camera. 
- [x] User can search and add friends.
- [x] User can only see his own posts and his friends' posts on the home feed.
- [x] User gets notified when their food is about to expire.

<img src='https://i.imgur.com/Cqf6MJJ.gif' title='Part 1 Walkthrough' width='' alt='Part 1 Walkthrough' />

### App-Pitch-Presentation

**Coming Soon**

### Authors

### JJDProductions:

* **Joshua Tavassolikhah** - [JoshTavasso](https://github.com/JoshTavasso)

* **Justin Leong** - [justinleong360](https://github.com/justinleong360)

* **David Yip** - [davidyip50](https://github.com/davidyip50)

## Process of building this application

All authors collaborated together on 1 laptop at a time. Work was always done together and all features were implemented as a team. 
