# Authentication-block

Hi! That's my mini-app using MVP.

Here is it.

## Project flowchart

![Flowchart](https://user-images.githubusercontent.com/106081917/196029086-e3e1a7b9-486e-4cd0-bf7e-42c3da611a2a.jpg)


| File | Description |
|:----|:----|
| 1. **Router** | Asks AssemblyModuleBuilder to create Modules (Presenter + View), shows Modules on the screen.  |
| 2. **AssemblyModuleBuilder** | Creates Modules |
| 3. **NetworkService** | Contatins all the network methods: check inthernet, download image |
| 4. **FirebaseService** | Contains all the Firebase methods: try to log in, try to sign up, log out, delete current user account |
| 5. and 6. **Presenters** | 1._Contains all the methods that connect the view and the network layer, the view and the router.  2. Presenters can manage views.  3._Presenters are independet from each other. |
| **Views** | 1. Contains only UI methods. 2. View are independet from each other. |



**Here additional info about AppDelegate and SceneDelegate to understand the whole flow**  
<img width="663" alt="AppDelegate and SceneDelegate" src="https://user-images.githubusercontent.com/106081917/196030835-5516df03-b676-4214-9c2e-98983ed68445.png">

## Interface  
### Registration process  

**1.0 [StartHereViewController] First module**  
— internet check  
— downloading random screen-size image  
— button pushes (1.1)SIGN IN / REGISTRATION modal screen  
view | error handle
:-: | :-:
<video src='https://user-images.githubusercontent.com/106081917/196025793-fb98b076-8cc6-4466-aa84-98b9b5711ad9.mp4' width=180/> | <video src='https://user-images.githubusercontent.com/106081917/196025810-06bc90ed-de19-4fcb-9ba0-406391c11d42.mp4' width=180/>


**1.1 [SignInViewController] SIGN IN / REGISTRATION modal screen**  
— internet check  
— error handling  
— checking the data in the text field  
— button pushes (1.2)PASSWORD modal screen 

**1.2 [PasswordViewController] PASSWORD modal screen**  
— internet check  
— error handling  
— checking the data in the text field  
— button pushes either (1.3)REGISTRATION modal screen or (2.0)LOGGED IN USER screen  

**1.3 [RegistrationViewController] REGISTRATION modal screen**  
— internet check  
— error handling  
— checking the data in the text field 
1.1 SIGN IN / REGISTRATION modal screen | 1.2 PASSWORD modal screen | 1.3 REGISTRATION modal screen
:-: | :-: | :-:
<video src='https://user-images.githubusercontent.com/106081917/196026765-9a7a70fc-e38a-461e-9588-2c7ffa4eed82.mp4' width=180/> | <video src='https://user-images.githubusercontent.com/106081917/196026831-ee934f77-d0bb-41b2-8641-6a689755c50f.mp4' width=180/>  | <video src='https://user-images.githubusercontent.com/106081917/196026923-188c1d7f-6252-441b-9f4e-bc50ca872198.mp4' width=180/>

**2.0 [LoggedInViewController] LOGGED IN USER screen**  
— Label shows username  
— Delete account button  
— Deleting confirmation  
— Log out button  
<video src='https://user-images.githubusercontent.com/106081917/196027024-a2cc6a3c-49cd-4cf9-8f6a-ea6652965f44.mp4' width=180/>

#### The process of logging in and deleting an account

process of logging | deleting an account
:-: | :-:
<video src='https://user-images.githubusercontent.com/106081917/196027412-c8458534-4ea3-47d5-8a46-84b593603d3a.mp4' width=180/> | <video src='https://user-images.githubusercontent.com/106081917/196027423-f0cbec7f-e0b2-40bb-bd08-4b14e8b2a419.mp4' width=180/>



## Firbase responces

**Firebase Auth create account feedback**  
<img width="937" alt="Firebase Auth create account feedback" src="https://user-images.githubusercontent.com/106081917/196028983-b5e221aa-141b-4be2-9042-41694cd7cdbb.png">

**Firebse Database create account feedback**  
<img width="361" alt="Firebse Database create account feedback" src="https://user-images.githubusercontent.com/106081917/196028990-d4b12dfc-66c1-4265-9992-0ab5e3fdc161.png">

**Firebase database delete user feedback**  
<img width="389" alt="Firebase database delete user feedback" src="https://user-images.githubusercontent.com/106081917/196029011-8d70d47b-3526-4331-9ca7-5e18dfdeccae.png">




















