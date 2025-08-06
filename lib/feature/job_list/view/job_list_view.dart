import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/enums/pickup_type_enum.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/coordinate_model.dart';
import 'package:soforvarcom/feature/job_list/model/job_model.dart';
import 'package:soforvarcom/feature/job_list/view/job_details_view.dart';
import 'package:soforvarcom/feature/job_list/widget/job_card.dart';

class JobListView extends StatefulWidget {
  const JobListView({super.key});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  List<JobModel> _jobs = [];

  @override
  void initState() {
    super.initState();
    _loadMockJobs();
  }

  void _loadMockJobs() {
    _jobs = [
      JobModel(
        id: '1',
        fromProvince: 'KOCAELİ',
        toProvince: 'TRABZON',
        fromLocation: Coordinate(latitude: 40.7648, longitude: 29.9081),
        toLocation: Coordinate(latitude: 41.0015, longitude: 39.7178),
        fromCity: 'İzmit',
        toCity: 'Merkez',
        price: 2500,
        pickupType: JobType.pointToPoint,
        companyName: 'Kocaeli Nakliyat',
        contactInfo: '+90 262 123 45 67',
        description: 'Acil yük taşıma hizmeti',
        vehicleCount: 2,
      ),
      JobModel(
        id: '2',
        fromProvince: 'DENİZLİ',
        toProvince: 'ADANA',
        fromLocation: Coordinate(latitude: 37.7765, longitude: 29.0864),
        toLocation: Coordinate(latitude: 37.0000, longitude: 35.3213),
        fromCity: 'Merkez',
        toCity: 'Seyhan',
        price: 1800,
        pickupType: JobType.pointToPoint,
        companyName: 'Güney Lojistik',
        contactInfo: '+90 322 987 65 43',
        description: 'Tekstil ürünleri taşıma',
        vehicleCount: 1,
      ),
      JobModel(
        id: '3',
        fromProvince: 'ADANA',
        toProvince: 'AKSARAY',
        fromLocation: Coordinate(latitude: 37.0000, longitude: 35.3213),
        toLocation: Coordinate(latitude: 38.3687, longitude: 34.0370),
        fromCity: 'Seyhan',
        toCity: 'Merkez',
        pickupType: JobType.pointToPoint,
        companyName: 'Orta Anadolu Nakliye',
        contactInfo: '+90 382 456 78 90',
        description: 'Teklif usulü - detaylar için iletişime geçin',
        vehicleCount: 3,
      ),
      JobModel(
        id: '4',
        fromProvince: 'MARDİN',
        toProvince: 'İZMİR',
        fromLocation: Coordinate(latitude: 37.3212, longitude: 40.7245),
        toLocation: Coordinate(latitude: 38.4192, longitude: 27.1287),
        fromCity: 'Merkez',
        toCity: 'Konak',
        price: 3200,
        pickupType: JobType.fullDay,
        companyName: 'Doğu-Batı Lojistik',
        contactInfo: '+90 232 111 22 33',
        description: 'Günlük servis hizmeti',
        vehicleCount: 1,
      ),
      JobModel(
        id: '5',
        fromProvince: 'MARDİN',
        toProvince: 'KONYA',
        fromLocation: Coordinate(latitude: 37.3212, longitude: 40.7245),
        toLocation: Coordinate(latitude: 37.8713, longitude: 32.4846),
        fromCity: 'Merkez',
        toCity: 'Selçuklu',
        price: 2800,
        pickupType: JobType.hourly,
        companyName: 'Anadolu Express',
        contactInfo: '+90 332 444 55 66',
        description: 'Saatlik kiralama hizmeti',
        vehicleCount: 2,
      ),
      JobModel(
        id: '6',
        fromProvince: 'TRABZON',
        toProvince: 'ANKARA',
        fromLocation: Coordinate(latitude: 41.0015, longitude: 39.7178),
        toLocation: Coordinate(latitude: 39.9334, longitude: 32.8597),
        fromCity: 'Ortahisar',
        toCity: 'Çankaya',
        price: 2100,
        pickupType: JobType.pointToPoint,
        companyName: 'Karadeniz Nakliyat',
        contactInfo: '+90 312 777 88 99',
        description: 'Başkentte güvenli teslimat',
        vehicleCount: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: ListView.builder(
        padding: PaddingConstants.allMedium,
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return JobCard(
            job: job,
            index: index,
            onTap: () => _navigateToJobDetails(job),
          );
        },
      ),
    );
  }

  void _navigateToJobDetails(JobModel job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: JobDetailsBottomSheet(job: job),
      ),
    );
  }
}
