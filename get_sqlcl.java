//JAVA 11+

/**
 * SPDX-License-Identifier: Apache-2.0
 *
 * Copyright 2023 Andres Almiray
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Comparator;
import java.util.TreeMap;
import java.util.function.Predicate;

/**
 * @author aalmiray
 * @since May 2023
 */
class get_sqlcl {
    public static void main(String... args) throws Exception {
        // default version
        var version = "latest";

        if (args.length > 1) {
            System.err.println("Usage: java get_sqlcl.java [VERSION]");
            System.exit(1);
        }

        // grab the version
        if (args.length == 1) {
            version = args[0];
        }

        // check
        if (null == version || version.isEmpty()) {
            System.out.printf("❌ Version '%s' is invalid%n", version);
            System.exit(1);
        }

        var sqlclDirectory = Path.of(".sqlcl");
        Files.createDirectories(sqlclDirectory);

        var url = "https://raw.githubusercontent.com/gvenzl/setup-oracle-sqlcl/main/versions.txt";
        var file = sqlclDirectory.resolve("versions.txt");

        var versions = new TreeMap<String, String>(Comparator.reverseOrder());
        try (var stream = new URL(url).openStream()) {
            System.out.printf("✅ Located versions mapper file%n");
            Files.copy(stream, file, StandardCopyOption.REPLACE_EXISTING);
            Files.readAllLines(file).stream()
                .filter(Predicate.not(String::isBlank))
                .forEach(line -> {
                    String[] parts = line.split(",");
                    versions.put(parts[0].trim(), parts[1].trim());
                });
        } catch (IOException e) {
            System.out.printf("☠️  SQLcl %s could not be downloaded/copied%n", version);
            e.printStackTrace();
            System.exit(1);
        }

        if (!versions.containsKey(version)) {
            System.out.printf("❌ SQLcl %s could not be resolved%n", version);
            System.out.printf("Valid versions are %s%n", versions.keySet());
            System.exit(1);
        }

        var targetVersion = versions.get(version);
        if (!"latest".equals(version) && !version.equals(targetVersion)) {
            System.out.printf("ℹ️ Version %s resolves to %s%n", version, targetVersion);
        }
        url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-" + targetVersion + ".zip";
        file = sqlclDirectory.resolve("sqlcl.zip");

        try (InputStream stream = new URL(url).openStream()) {
            System.out.printf("⬇️ Downloading %s%n", url);
            long size = Files.copy(stream, file, StandardCopyOption.REPLACE_EXISTING);
            System.out.printf("sqlcl-" + targetVersion + " << copied %d bytes%n", size);
            System.out.println("✅ SQLcl downloaded successfully");
        } catch (FileNotFoundException e) {
            System.out.println("❌ SQLcl not found");
            System.exit(1);
        } catch (IOException e) {
            System.out.println("☠️  SQLcl could not be downloaded/copied");
            e.printStackTrace();
            System.exit(1);
        }
    }
}
