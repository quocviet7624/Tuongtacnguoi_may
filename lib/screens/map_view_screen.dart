import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 107,
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xFFC3C3C3))),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 22, color: Colors.black),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Bản đồ việc làm',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.30,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.tune, size: 28, color: Colors.black54),
                  ],
                ),
              ),
            ),

            // Map placeholder
            Container(
              width: double.infinity,
              height: 300,
              color: const Color(0xFFD0E8D0),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 64, color: Colors.green),
                    SizedBox(height: 8),
                    Text(
                      'Bản đồ Google Maps',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ),
            ),

            // Việc làm gần bạn
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: const Text(
                'Việc làm gần bạn',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.30,
                ),
              ),
            ),

            // Job list nearby
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                children: [
                  _buildNearbyJobCard(
                    context: context,
                    title: 'Nhân viên bán hàng',
                    salary: '15.000.000 VND/tháng',
                  ),
                  const SizedBox(height: 8),
                  _buildNearbyJobCard(
                    context: context,
                    title: 'Thợ sửa chữa điện',
                    salary: '18.000.000 VND/tháng',
                  ),
                  const SizedBox(height: 8),
                  _buildNearbyJobCard(
                    context: context,
                    title: 'Nhân viên phục vụ',
                    salary: '12.500.000 VND/tháng',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyJobCard({
    required BuildContext context,
    required String title,
    required String salary,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/job-detail'),
      child: Container(
        height: 90,
        decoration: ShapeDecoration(
          color: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 37,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7200),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.30,
                  ),
                ),
              ),
              Text(
                salary,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}