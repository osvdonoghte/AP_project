import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class SignupServer {
    private static final int PORT = 12345;

    // File to store user details
    private static final String USER_FILE = "Users.txt";

    public static void main(String[] args) {
        // Start the server
        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            System.out.println("Signup Server started on port " + PORT);

            while (true) {
                // Accept client connections in a loop
                Socket clientSocket = serverSocket.accept();
                System.out.println("Client connected: " + clientSocket.getInetAddress());

                // Handle each client in a new thread
                new Thread(() -> handleClient(clientSocket)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void handleClient(Socket clientSocket) {
        try (
            BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)
        ) {
            // Read a line from the client: e.g. "username email password"
            String command = in.readLine();

            if (command != null) {
                String[] parts = command.split(" ");
                // Expected: parts[0] = username, parts[1] = email, parts[2] = password
                if (parts.length == 3) {
                    String username = parts[0];
                    String email = parts[1];
                    String password = parts[2];

                    // Handle signup (check/append to file)
                    String result = handleSignup(username, email, password);
                    out.println(result);
                } else {
                    out.println("ERROR: Invalid data format");
                }
            } else {
                out.println("ERROR: No command received");
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                clientSocket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private static synchronized String handleSignup(String username, String email, String password) {
        // Check if Users.txt exists; if not, create it
        File file = new File(USER_FILE);
        try {
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
            return "ERROR: Could not create user file";
        }

        // 1) Check if the email already exists
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Each line format: username email password معمولی
                String[] tokens = line.split(" ");
                if (tokens.length >= 2) {
                    String existingEmail = tokens[1];  // Email is the second field
                    if (existingEmail.equals(email)) {
                        return "ERROR: Email already exists";
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return "ERROR: Could not read user file";
        }

        // 2) If email does not exist, append to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(username + " " + email + " " + password + " معمولی");
            writer.newLine();
            writer.flush();
            return "SUCCESS: User created";
        } catch (IOException e) {
            e.printStackTrace();
            return "ERROR: Could not write to user file";
        }
    }
}
