// LoginServer.java
import java.io.*;
import java.net.*;

public class LoginServer {
    private static final int PORT = 12345;
    private static final String USER_FILE = "Users.txt";

    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            System.out.println("Login Server started on port " + PORT);

            while (true) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("Client connected: " + clientSocket.getInetAddress());
                
                new Thread(new ClientHandler(clientSocket)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static class ClientHandler implements Runnable {
        private Socket clientSocket;

        public ClientHandler(Socket socket) {
            this.clientSocket = socket;
        }

        @Override
        public void run() {
            try (
                BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)
            ) {
                String request = in.readLine();
                System.out.println("Request received: " + request);

                if (request != null) {
                    String[] parts = request.split(" ");
                    if (parts.length == 2) {
                        String username = parts[0];
                        String password = parts[1];

                        if (authenticateUser(username, password)) {
                            out.println("SUCCESS: Login successful");
                        } else {
                            out.println("ERROR: Invalid username or password");
                        }
                    } else {
                        out.println("ERROR: Invalid request format");
                    }
                } else {
                    out.println("ERROR: Unsupported request");
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

        private boolean authenticateUser(String username, String password) {
            synchronized (USER_FILE) {
                try (BufferedReader reader = new BufferedReader(new FileReader(USER_FILE))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String[] parts = line.split(" ");
                        if (parts.length >= 4 && parts[0].equals(username) && parts[2].equals(password)) {
                            return true;
                        }
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return false;
            }
        }
        
            }
}
