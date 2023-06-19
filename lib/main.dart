import 'package:firebase_project/views/splashView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SplashView(),
    );
  }
}
// To add your Flutter project to GitHub, you can follow these steps:

// 1. Create a new repository on GitHub: Go to GitHub (https://github.com/) and sign in to your account. Click on the "New" button to create a new repository. Provide a name for your repository and choose any additional settings as needed. Click on "Create repository" to finalize the creation.

// 2. Initialize Git in your Flutter project: Open a terminal or command prompt and navigate to the root directory of your Flutter project. Initialize Git in this directory by running the following command:

//    ```bash
//    git init
//    ```

// 3. Create a `.gitignore` file: Create a file named `.gitignore` in the root directory of your Flutter project. This file lists the files and directories that Git should ignore when tracking changes. You can generate a suitable `.gitignore` file for Flutter projects by using the gitignore.io website (https://www.gitignore.io/). Select "Flutter" as the technology and generate the file contents. Copy the generated contents and paste them into your `.gitignore` file.

// 4. Add and commit your project files: Use the following commands to add all the files in your Flutter project to the Git repository and make an initial commit:

//    ```bash
//    git add .
//    git commit -m "Initial commit"
//    ```

// 5. Add the remote repository: In the GitHub repository that you created earlier, copy the repository's remote URL. Back in your terminal or command prompt, add the remote repository using the following command:

//    ```bash
//    git remote add origin [remote repository URL]
//    ```

// 6. Push your project to GitHub: Finally, push your local repository to GitHub using the following command:

//    ```bash
//    git push -u origin master
//    ```

//    If you're using a different branch instead of the `master` branch, adjust the command accordingly.

// After executing these steps, your Flutter project will be added to the GitHub repository, and you'll be able to view and manage your code on GitHub.
