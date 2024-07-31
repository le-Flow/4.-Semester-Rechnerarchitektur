/**
 * @author mock
 * v 1.0
 * SoSe 2020
 */

import java.util.HashSet;
import java.util.Set;

public class CacheSimulator {

    private final int cacheLines;
    private final int associativity;
    private final int blockSize;
    private final String filename;
    private final boolean verbose;
    private final ValgrindLineParser valgrindParser;
    private CacheLine[][] cache;

    private int totalAccesses;
    private int totalHits;
    private int totalMisses;

    // TODO Add something to represent the cache entries (tags and valid bits, no data)
    private class CacheLine {
        long tag;
        boolean valid;
        long lastAccessTime;

        CacheLine() {
            tag = -1;
            valid = false;
            lastAccessTime = -1;
        }
    }


    CacheSimulator(int cacheLines, int associativity, int blockSize, String filename, boolean verbose) {
        this.cacheLines = cacheLines;
        this.associativity = associativity;
        this.blockSize = blockSize;
        this.filename = filename;
        this.verbose = verbose;
        valgrindParser = new ValgrindLineParser(filename);
        setup();  // do some setup stuff before the simulation

    }

    private void setup() {
        // TODO prepare the simulation
        // Initialize the cache
        cache = new CacheLine[cacheLines / associativity][associativity];
        for (int i = 0; i < cache.length; i++) {
            for (int j = 0; j < cache[i].length; j++) {
                cache[i][j] = new CacheLine();
            }
        }

        // Initialize statistics
        totalAccesses = 0;
        totalHits = 0;
        totalMisses = 0;
    }

    public void simulate() {
        ValgrindLineParser.ValgrindLine line = null;
        Set<Integer> sizes = new HashSet<Integer>();

        while ((line = valgrindParser.getNext()) != null) {
            long clock = valgrindParser.getLineNumber();  // we use the line number as a logical clock 
            sizes.add(line.size);
            switch (line.accessKind) {
                case 'L':
                    simulateLoad(line, clock);
                    break;
                case 'M':
                    simulateLoad(line, clock);
                    simulateStore(line, clock);
;                    break;
                case 'S':
                    simulateStore(line, clock);
                    break;
                case 'I':
                    // nothing to do for D cache
                    break;
                default:
                    // hmm that should not happen
                    System.out.println("Don't know how to simulate access kind " + line.accessKind);
                    break;
            }

        }
        System.out.println("Successfully simulated " + valgrindParser.getLineNumber() + " valgrind lines");
        System.out.println("Access sizes in trace: ");
        for (int size : sizes) {
            System.out.print(size + " ");
        }
        System.out.println("");
        // TODO Hier geben Sie die Gesamtstatistik aus
        System.out.println("Total accesses: " + totalAccesses);
        System.out.println("Cache hits: " + totalHits);
        System.out.println("Cache misses: " + totalMisses);
        System.out.println("Hit rate: " + ((double) totalHits / totalAccesses * 100) + "%");
        System.out.println("Miss rate: " + ((double) totalMisses / totalAccesses * 100) + "%");
    }

    private int log2(int x) {
        int result = 0;
        while (x > 1) {
            result ++;
            x = x >> 1;
        }
        return result;
    }



    private void simulateStore(ValgrindLineParser.ValgrindLine line, long clock) {
        if (verbose) {
            System.out.print("store " + Long.toString(line.address, 16) + " " + line.size);
        }
        simulateAccess(line, clock);
    }

    private void simulateLoad(ValgrindLineParser.ValgrindLine line, long clock) {
        if (verbose) {
            System.out.print("load " + Long.toString(line.address, 16) + " " + line.size);
        }
        simulateAccess(line, clock);

    }

    private void simulateAccess(ValgrindLineParser.ValgrindLine line, long clock) {
	// TOOD the main part 
        long address = line.address;
        int indexBits = log2(cacheLines / associativity);
        int blockBits = log2(blockSize);
        int index = (int) ((address >> blockBits) & ((1 << indexBits) - 1));
        long tag = address >> (indexBits + blockBits);

        CacheLine[] set = cache[index];
        boolean hit = false;
        for (CacheLine cacheLine : set) {
            if (cacheLine.valid && cacheLine.tag == tag) {
                hit = true;
                cacheLine.lastAccessTime = clock;
                totalHits++;
                break;
            }
        }

        if (!hit) {
            // Cache miss: find an empty line or replace an existing one
            CacheLine lruLine = null;
            for (CacheLine cacheLine : set) {
                if (!cacheLine.valid) {
                    lruLine = cacheLine;
                    break;
                }
                if (lruLine == null || cacheLine.lastAccessTime < lruLine.lastAccessTime) {
                    lruLine = cacheLine;
                }
            }

            // Replace the LRU line
            lruLine.tag = tag;
            lruLine.valid = true;
            lruLine.lastAccessTime = clock;
            totalMisses++;
        }

        totalAccesses++;

        if (verbose) {
            System.out.println(hit ? " hit" : " miss");
        }
    }
}
