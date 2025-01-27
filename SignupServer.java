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
    
    // File to store user details (username||password)
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
            BufferedReader in = new BufferedReader(
                new InputStreamReader(clientSocket.getInputStream())
            );
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)
        ) {
            // Read a line from the client: e.g. "SIGNUP||john_doe||secret123"
            String command = in.readLine();  

            if (command != null && command.startsWith("SIGNUP")) {
                String[] parts = command.split("\\|\\|");
                // Expected: parts[0] = "SIGNUP", parts[1] = username, parts[2] = password
                if (parts.length == 3) {
                    String username = parts[1];
                    String password = parts[2];

                    // Handle signup (check/append to file)
                    String result = handleSignup(username, password);
                    out.println(result);
                } else {
                    out.println("ERROR: Invalid data format");
                }
            } else {
                out.println("ERROR: Unknown command");
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

    private static synchronized String handleSignup(String username, String password) {
        // Check if users.txt exists; if not, create it
        File file = new File(USER_FILE);
        try {
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
            return "ERROR: Could not create user file";
        }

        // 1) Check if the username already exists
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Each line format: username||password
                String[] tokens = line.split("\\|\\|");
                if (tokens.length == 2) {
                    String existingUsername = tokens[0];
                    // Compare to see if user already exists
                    if (existingUsername.equals(username)) {
                        return "ERROR: Username already exists";
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return "ERROR: Could not read user file";
        }

        // 2) If user does not exist, append to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            // Append a newline if the file isn't empty
            writer.write(username + "||" + password);
            writer.newLine();
            writer.flush();
            return "SUCCESS: User created";
        } catch (IOException e) {
            e.printStackTrace();
            return "ERROR: Could not write to user file";
        }
    }
}
